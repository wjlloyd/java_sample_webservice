/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package services;

import java.io.IOException;
import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PUT;
import javax.ws.rs.core.MediaType;
import org.codehaus.jackson.map.ObjectMapper;
import objects.FibonacciNumber;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

/**
 * REST Web Service
 *
 * @author wlloyd
 */
@Path("fibonacci")
public class FibonacciService {

    static final java.util.logging.Logger log = java.util.logging.Logger.getLogger(FibonacciService.class.getName());
    
    @Context
    private UriInfo context;

    /**
     * Creates a new instance of GenericResource
     */
    public FibonacciService() {
    }

    /**
     * Retrieves representation of an instance of services.GenericResource
     * @return an instance of java.lang.String
     */
    @GET
    @Produces(MediaType.TEXT_HTML)
    public String getXml() {
        log.info("Fibonacci GET");
        return "<html><body>Fibonacci Service</body></html>";
    }

    /**
     * PUT method for updating or creating an instance of GenericResource
     * @param content representation for the resource
     */
    @PUT
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes(MediaType.TEXT_PLAIN)
    public String putXml(String content) {
        String sText = "The user just put=" + content;
        log.info("Fibonacci PUT");
        log.info(sText);
        return sText;
    }
    
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public String PostJson(String jobj) throws JSONException, IOException {
        log.info("Fibonacci POST");
        ObjectMapper mapper = new ObjectMapper();
        FibonacciNumber fn = mapper.readValue(jobj.toString(), FibonacciNumber.class);
        
        StringBuilder text = new StringBuilder();
        text.append("The JSON obj:" + jobj.toString() + "\n");
        text.append("Request for fibonacci number for:" + fn.getNumber()+ "\n");
        log.info(text.toString());
        
        //BigInteger bn = fibonacci3(fn.getNumber()-1);
        BigInteger bn2 = fibonacci(fn.getNumber());
        
        JSONObject fiboans = new JSONObject();
        fiboans.append("number", fn.getNumber());
        //fiboans.append("fibonacci_rec", bn.toString());
        fiboans.append("fibonacci_seq", bn2.toString());
        
        return fiboans.toString();
    }
    
    
    private Map<Integer, BigInteger> memo = new HashMap<>();

    // Recursive fibonacci
    // Using Java we run out of stack space with large numbers
    public BigInteger fibonacci3(int n) {
        if (n == 0 || n == 1) {
            return BigInteger.ONE;
        }
        if (memo.containsKey(n)) {
            return memo.get(n);
        }
        BigInteger v = fibonacci3(n - 2).add(fibonacci3(n - 1));
        memo.put(n, v);
        return v;
    }    
    
    // Iterative fibonacci
    // Slower, but can handle larger numbers
    public BigInteger fibonacci(int n)
    {
        int i=0;
        BigInteger[] vec = new BigInteger[n+1];
        vec[0]=BigInteger.ZERO;
        vec[1]=BigInteger.ONE;
        // calculating
        for(i = 2 ; i<=n ; i++){
            //System.out.println("i=" + i + " n=" + n + " i-1=" + (i-1) + " i-2=" + (i-2));
            vec[i]=vec[i-1].add(vec[i-2]);
        }
        //System.out.println("RETURNING n=" + (n));
        return vec[n];
    }
}
