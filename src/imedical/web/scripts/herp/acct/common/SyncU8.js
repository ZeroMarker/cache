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

/// Action-操作(add:新增  edit:更新 delete:删除) VenCode-供应商工商执照 
/// VenName-供应商名称 VenType-供应商类别(物资供应商：04 药品供应商：03) Date-创建日期
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
		+"	<cvenexch_name>人民币</cvenexch_name>"
		+"	<dvencreatedatetime>"+Date+"</dvencreatedatetime>"
		+"  <bvencargo>1</bvencargo>"
		+"</vendor>"
	   +"</ufinterface>";
	   	   
	 Sync(str);

}