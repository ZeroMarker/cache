var Sync=function(str)
{
	var url=u8url	
	var xmlHttp="";
						
	if (window.XMLHttpRequest)
    {
        xmlHttp = new XMLHttpRequest();
        
        if (xmlHttp.overrideMimeType)
        {
            xmlHttp.overrideMimeType("text/xml");
        }
    }
    else if (window.ActiveXObject)
    {
        try
        {
            xmlHttp = new ActiveXObject("Mscml2.XMLHTTP");
        }
        catch(e)
        {
            try
            {
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch(ex)
            {}
        }
    }
  
    if(xmlHttp)	 
    {    	
		xmlHttp.open("POST",url,true);
		
		xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");	
				
		xmlHttp.send(str);		
				
    }	
 
}

/// Action-����(add:����  edit:���� delete:ɾ��) VenCode-��Ӧ�̹���ִ�� 
/// VenName-��Ӧ������ VenType-��Ӧ�����(���ʹ�Ӧ�̣�04 ҩƷ��Ӧ�̣�03) Date-��������
/// SyncVen(Action,VenCode,VenName,VenType,Date)
var SyncVen=function (Action,VenCode,VenName,VenType,Date)
{
	var str="";
	
	if(VenCode=="") return;
	
	str="<ufinterface sender=\"999\" receiver=\"u8\" roottag=\"vendor\" "+"proc=\""+Action+"\">"
		+"<vendor>"
		+"	<code>"+VenCode+"</code>"
		+"	<name>"+VenName+"</name>"
		+"	<abbrname>"+VenName+"</abbrname>"
		+"  <seed_date>"+Date+"</seed_date>"
		+"	<sort_code>"+VenType+"</sort_code>"
		+"	<cvenexch_name>�����</cvenexch_name>"
		+"	<dvencreatedatetime>"+Date+"</dvencreatedatetime>"
		+"  <bvencargo>1</bvencargo>"
		+"</vendor>"
	   +"</ufinterface>";
	   	   
	 Sync(str);

}