global class SaveReceipts implements Schedulable {

    private static String saveReceiptsResult;
    private static Integer receiptCount = 0;
    private static Map<String, Object> readJSONString;
    
    private static void searchReceiptCount() {
        
        try {
            
            for (ShoppingCartReceipt__c eachReceipt: [SELECT Id FROM ShoppingCartReceipt__c
                                                                  ORDER BY CreatedDate DESC]) {
                
                receiptCount++;
            }
        } catch(DMLException e) {
            
            receiptCount = 0;
        }
    }
    
    //This method initializes a connection to the REST API.
    @future(callout=true)
    public static void saveReceipts() {
        
        String requestUrl = '';
        String[] find = new String[2];
        String[] replace = new String[2];
        Map<String, Id> useShoppingCartSalesCategory = new Map<String, Id>();
        Map<String, Id> useShoppingCartReceipt = new Map<String, Id>();
        List<ShoppingCartReceipt__c> receiptsToInsert = new List<ShoppingCartReceipt__c>();
        List<ShoppingCartItemSold__c> soldItemsToInsert = new List<ShoppingCartItemSold__c>();
        
        find[0] = '&apos;';
        find[1] = '&quot;';
        
        replace[0] = '\'';
        replace[1] = '"';
        
        //Search sales categories.
        try {
            
            for (ShoppingCartSalesCategory__c eachSalesCategory: [SELECT Id, Name FROM ShoppingCartSalesCategory__c
                                                                  ORDER BY CreatedDate DESC]) {
                
                useShoppingCartSalesCategory.put(eachSalesCategory.Name, eachSalesCategory.Id);
            }
            
            saveReceiptsResult = 'success';
        } catch (DMLException e) {
           
            System.debug(e.getMessage());
            
            saveReceiptsResult = 'fail';
        }
        
        //Sale categories must be available.
        if (saveReceiptsResult == 'success') {
            
            try {
                
                Http http = new Http();
                HttpRequest httpRequest = new HttpRequest();
                HttpResponse httpResponse = new HttpResponse();
                httpRequest.setTimeout(120000);
                
                httpRequest.setEndpoint('https://shopping-cart-java.herokuapp.com/admin-extract-receipts');
                httpRequest.setMethod('POST');
                httpRequest.setBody(requestUrl);
                
                httpResponse = http.send(httpRequest);
                
                readJSONString = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody().replace(', {}', ''));
                
                List<Object> receipts = (List<Object>)readJSONString.get('receipts');
                
                for (Object eachReceipt: receipts) {
                    
                    Map<String, Object> receiptFields = (Map<String, Object>)eachReceipt;
                    
                    if (String.valueOf(receiptFields.get('receipt')) != '0') {
                        
                    	ShoppingCartReceipt__c newShoppingCartReceipt = new ShoppingCartReceipt__c(
                    	Name = 'Receipt ' + String.valueOf(Integer.valueOf(receiptFields.get('receipt')) + receiptCount)
                    	);
                        
                        receiptsToInsert.add(newShoppingCartReceipt);
                    }
                }
                
                if (receiptsToInsert.size() > 0) {
                    
                    insert receiptsToInsert;
               	}
                
                saveReceiptsResult = 'success';
            } catch (DMLException e) {
                
                System.debug(e.getMessage());
                
                saveReceiptsResult = 'fail';
            } catch (Exception e) {
                
                System.debug(e.getMessage());
                
                saveReceiptsResult = 'fail';
            }
            
            //After receipts are saved they have to be referenced, so that all related items are correctly
            //associated with each receipt.
            if (saveReceiptsResult == 'success') {
                
                try {
                    
                    //Search each receipt for reference purposes.
                    for (ShoppingCartReceipt__c eachReceipt: [SELECT Id, Name FROM ShoppingCartReceipt__c
                                                              ORDER BY CreatedDate DESC]) {
                                                                  
                        useShoppingCartReceipt.put(eachReceipt.Name, eachReceipt.Id);
                    }
                    
                    saveReceiptsResult = 'success';
                } catch (DMLException e) {
                    
                    System.debug(e.getMessage());
                    
                    saveReceiptsResult = 'fail';
                }
            }
            
            if (saveReceiptsResult == 'success') {
                
                try {
                    
                    List<Object> itemsSold = (List<Object>)readJSONString.get('items_sold');
                    
                    for (Object eachItemSold: itemsSold) {
                        
                        Map<String, Object> itemSoldFields = (Map<String, Object>)eachItemSold;
                        
                        if (useShoppingCartSalesCategory.get(String.valueOf(itemSoldFields.get('category'))) != null) {

                        	ShoppingCartItemSold__c newShoppingCartItemSold = new ShoppingCartItemSold__c(
                        	ItemName__c = String.valueOf(itemSoldFields.get('item')).replace(find[0], replace[0]).replace(find[1], replace[1]),
                        	Thumbnail__c = String.valueOf(itemSoldFields.get('thumbnail')).replace(find[0], replace[0]).replace(find[1], replace[1]),
                        	Category__c = useShoppingCartSalesCategory.get(String.valueOf(itemSoldFields.get('category'))),
                        	Description__c = String.valueOf(itemSoldFields.get('description')).replace(find[0], replace[0]).replace(find[1], replace[1]),
                        	TotalPrice__c = Decimal.valueOf(String.valueOf(itemSoldFields.get('total_price'))),
                        	ShoppingCartReceipt__c = useShoppingCartReceipt.get('Receipt ' + String.valueOf(itemSoldFields.get('receipt_id')))
                        	);

							soldItemsToInsert.add(newShoppingCartItemSold);                            
                        }
                    }
                    
                    if (soldItemsToInsert.size() > 0) {
                        
                        insert soldItemsToInsert;
                    }
                } catch (DMLException e) {
                    
                    System.debug(e.getMessage());
                } catch (Exception e) {
                    
                    System.debug(e.getMessage());
                }
            }
        }
    }
    
    public static void manageReceipts() {
        
        searchReceiptCount();
        saveReceipts();
    }
    
    global static void execute(SchedulableContext runSchedule) {
        
        manageReceipts();
    }
}
