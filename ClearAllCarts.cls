global class ClearAllCarts implements Schedulable {

    //This method initializes a connection to the REST API.
    @future(callout=true)
    public static void clearAllCartsOnOtherServer() {
        
        String requestUrl = '';
        Long myDateTime = DateTime.now().getTime();
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        
        httpRequest.setTimeout(120000);
        
        requestUrl = 'raw_time_received=' + Integer.valueOf((myDateTime / 1000) / 60) + '&clear_all_carts=Clear all carts';
        httpRequest.setEndpoint('https://shopping-cart-java.herokuapp.com/clear-all-carts');
        httpRequest.setMethod('POST');
        httpRequest.setBody(requestUrl);
        
        httpResponse = http.send(httpRequest);
        
       	System.debug('Carts cleared ' + httpResponse.getBody());
    }
    
    global static void execute(SchedulableContext runSchedule) {
        
        clearAllCartsOnOtherServer();
    }
}
