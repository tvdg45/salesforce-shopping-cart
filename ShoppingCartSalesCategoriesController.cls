public class ShoppingCartSalesCategoriesController {

    //This method initializes a connection to the REST API.
    @future(callout=true)
    public static void addSalesCategoriesToOtherServer(String[] allCategoryNames, String[] allCategoryIds) {
        
        String requestUrl = '';
        String categoryNamesString = '';
        String categoryIdsString = '';
        
        for (Integer i = 0; i < allCategoryNames.size(); i++) {
            
            categoryNamesString += allCategoryNames[i] + ';';
        }
        
        for (Integer i = 0; i < allCategoryIds.size(); i++) {
            
            categoryIdsString += allCategoryIds[i] + ';';
        }
        
        categoryNamesString += ';{}';
        categoryIdsString += ';{}';
        
        categoryNamesString = categoryNamesString.replace(';{}', '');
        categoryIdsString = categoryIdsString.replace(';{}', '');
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        
        requestUrl = 'category=' + categoryNamesString + '&external_id=' + categoryIdsString + '&add_categories=Add categories';
        httpRequest.setEndpoint('https://shopping-cart-java.herokuapp.com/admin-change-for-sale-item-categories');
        httpRequest.setMethod('POST');
        httpRequest.setBody(requestUrl);
        
        httpResponse = http.send(httpRequest);
        
       	System.debug('Categories added ' + httpResponse.getBody());
    }
    
    //This method initializes a connection to the REST API.
    @future(callout=true)
    public static void changeSalesCategoriesOnOtherServer(String[] allCategoryNames, String[] allCategoryIds) {
        
        String requestUrl = '';
        String categoryNamesString = '';
        String categoryIdsString = '';
        
        for (Integer i = 0; i < allCategoryNames.size(); i++) {
            
            categoryNamesString += allCategoryNames[i] + ';';
        }
        
        for (Integer i = 0; i < allCategoryIds.size(); i++) {
            
            categoryIdsString += allCategoryIds[i] + ';';
        }
        
        categoryNamesString += ';{}';
        categoryIdsString += ';{}';
        
        categoryNamesString = categoryNamesString.replace(';{}', '');
        categoryIdsString = categoryIdsString.replace(';{}', '');
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        
        requestUrl = 'category=' + categoryNamesString + '&external_id=' + categoryIdsString + '&change_categories=Change categories';
        httpRequest.setEndpoint('https://shopping-cart-java.herokuapp.com/admin-change-for-sale-item-categories');
        httpRequest.setMethod('POST');
        httpRequest.setBody(requestUrl);
        
        httpResponse = http.send(httpRequest);
        
       	System.debug('Categories changed ' + httpResponse.getBody());
    }
    
    //This method initializes a connection to the REST API.
    @future(callout=true)
    public static void deleteSalesCategoriesFromOtherServer(String[] allCategoryNames, String[] allCategoryIds) {
        
        String requestUrl = '';
        String categoryNamesString = '';
        String categoryIdsString = '';
        
        for (Integer i = 0; i < allCategoryNames.size(); i++) {
            
            categoryNamesString += allCategoryNames[i] + ';';
        }
        
        for (Integer i = 0; i < allCategoryIds.size(); i++) {
            
            categoryIdsString += allCategoryIds[i] + ';';
        }
        
        categoryNamesString += ';{}';
        categoryIdsString += ';{}';
        
        categoryNamesString = categoryNamesString.replace(';{}', '');
        categoryIdsString = categoryIdsString.replace(';{}', '');
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        
        requestUrl = 'category=' + categoryNamesString + '&external_id=' + categoryIdsString + '&delete_categories=Delete categories';
        httpRequest.setEndpoint('https://shopping-cart-java.herokuapp.com/admin-change-for-sale-item-categories');
        httpRequest.setMethod('POST');
        httpRequest.setBody(requestUrl);
        
        httpResponse = http.send(httpRequest);
        
       	System.debug('Categories deleted ' + httpResponse.getBody());
    }
    
    //A before trigger utilizes this method
    public static void validateShoppingCartSalesCategory(List<ShoppingCartSalesCategory__c> allSalesCategories) {
        
        for (ShoppingCartSalesCategory__c eachSavedSalesCategory: [SELECT Name FROM ShoppingCartSalesCategory__c]) {
            
            for (ShoppingCartSalesCategory__c eachSalesCategoryToBeSaved: allSalesCategories) {
                
                if (eachSalesCategoryToBeSaved.Name != null) {
                    
                    if (eachSalesCategoryToBeSaved.Name == eachSavedSalesCategory.Name) {
                        
                        eachSalesCategoryToBeSaved.addError('You already have a sales category by the name. ' +
                                                         'Please choose a different name.');
                    }
                }
            }
        }
    }
}
