//名称	DHCPEFeeListNew.js
//组件  DHCPEFeeListNew
//功能	拆分
//创建	2018.09.28
//创建人  xy
document.body.style.padding="0px 10px 0px 10px"
function BodyLoadHandler()
{	
	$("#Name").keydown(function(e) {
			
			if(e.keyCode==13){
				Query_Click();
			}
			
        });    
         
	$("#Query").click(function() {
			
			Query_Click();	
			
        });	 
}

function Query_Click(){
		
	 var iName=getValueById("Name");
     var iSplitType=getValueById("SplitType");
     var iPreAudits=getValueById("PreAudits");
     var iSelectIds=getValueById("SelectIds");
     var iARCIMID=getValueById("ARCIMID");
     var iOrdSetID=getValueById("OrdSetID");

     var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEFeeListNew"
			+"&SplitType="+iSplitType
			+"&Name="+iName
			+"&PreAudits="+iPreAudits
			+"&SelectIds="+iSelectIds
			+"&ARCIMID="+iARCIMID
			+"&OrdSetID="+iOrdSetID
			;
            //alert(lnk)
    location.href=lnk; 
	
}

var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{
	  	
	}else
	{
		SelectedRow=-1;
	
	}

}



document.body.onload = BodyLoadHandler;