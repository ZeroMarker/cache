 $.IEVersion = function() {           
 var userAgent = navigator.userAgent.toLowerCase(); //ȡ���������userAgent�ַ���              
 var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("msie") > -1; //�ж��Ƿ�IE<11�����              
 var isEdge = userAgent.indexOf("edge") > -1 && !isIE; //�ж��Ƿ�IE��Edge�����              
 var isIE11 = userAgent.indexOf('trident') > -1 && userAgent.indexOf("rv:11.0") > -1;            
 //alert("userAgent = "+userAgent+" isIE = "+isIE+"  isEdge = "+isEdge+" isIE11 = "+isIE11);            
 if (isIE) 
   {               
	   var reIE = new RegExp("msie (\\d+\\.\\d+);");                
	   reIE.test(userAgent);                
	   var fIEVersion = parseFloat(RegExp["$1"]);                
	   if (fIEVersion == 7) 
	   {                    
	   return 7;                
	   } 
	   else if (fIEVersion == 8) 
	   {                    
	   return 8;                
	   } 
	   else if (fIEVersion == 9) 
	   {                    
	   return 9;                
	   } 
	   else if (fIEVersion == 10) 
	   {                    
	   return 10;                
	   } 
	   else 
	   {                    
	   return 6; //IE�汾<=6                
	   }            
    } 
 else if (isEdge) 
   {                
      return 'edge'; //edge           
   } 
 else if (isIE11) 
   {                
   return 11; //IE11             
   }            
 return -1; //����ie�����       
 }