global class DeleteReceipts implements Schedulable {

    //This method initializes a connection to the REST API.
    @future(callout=true)
    public static void deleteReceipts() {
        
        String requestUrl = '';
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        
        httpRequest.setTimeout(120000);
        
        requestUrl = 'delete_receipts=Delete receipts';
        httpRequest.setEndpoint('https://shopping-cart-java.herokuapp.com/admin-delete-receipts');
        httpRequest.setMethod('POST');
        httpRequest.setBody(requestUrl);
        
        httpResponse = http.send(httpRequest);
        
       	System.debug('Receipts deleted ' + httpResponse.getBody());
    }
    
    global static void execute(SchedulableContext runSchedule) {
        
        deleteReceipts();
    }
}
