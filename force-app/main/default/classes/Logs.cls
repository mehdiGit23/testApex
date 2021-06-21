public with sharing class Logs {
 
//Save information log
public static void info(String className, String task, String description){
    Logs__c log = new Logs__c();
    log.ClassName__c = className;
    log.Description__c=description;
    log.TaskName__c = task;
    log.log_level__c =Level.info.name();
    Insert log;
}
 
//Save success log
public static void trace(String className,String task,String description ){
    Logs__c log = new Logs__c();
    log.ClassName__c = className;
    log.TaskName__c = task;
    log.Description__c=description;
    log.log_level__c = Level.trace.name();
    Insert log;
}
 
//Save exception log
public static void error(String className,String task, Exception e){
    Logs__c log = new Logs__c();
    log.TaskName__c = task;
    log.ClassName__c = className;
    log.Stacktrace__c = e.getStackTraceString();
    log.message_error__c = e.getMessage();
    log.log_level__c = Level.error.name();
    log.Line_Number__c = e.getLineNumber();
    Insert log;
}
 //Save HTTP request log
public static void logHTTPRequest(String className, String methodName, String description, HttpRequest request){
    Logs__c log = new Logs__c();
    log.ClassName__c = className;
   
   // log.Description__c = description;
    log.log_level__c = Level.info.name();
    if(request != null){
        log.http_request__c = request.getBody();
               
    }
    Insert log;
}
//Save HTTP response log
public static void logHTTPResponse(String className, String methodName, String description, HttpResponse response){
    Logs__c log = new Logs__c();
    log.ClassName__c = className;
   
   // log.Description__c = description;
    log.log_level__c = Level.info.name();
    if(response != null){
        log.http_response__c = response.getBody();
        log.http_status_code__c = response.getStatusCode();         
    }
    Insert log;
}
    
    public enum Level{
        info,
        trace,
        debug,
        error
     }
}