
//名称	DHCPESplitAudit.js
//组件  DHCPESplitAudit
//功能	拆分
//创建	2018.09.27
//创建人  xy
document.body.style.padding="10px 10px 0px 10px"
function BodyLoadHandler()
{
	InitPage();
 
    //拆分类型
	$("#SplitType").combobox({
       onSelect:function(){
			SplitTypeChanged();
	}
	});

}
function SplitTypeChanged(){
	
	var SplitType=getValueById("SplitType");
	var AuditID=getValueById("AuditID");
	var ToAuditID=getValueById("ToAuditID");
	var ARCIMID=getValueById("ARCIMID");
	var OrdSetID=getValueById("txtItemSetId");
	var lnk="dhcpe2feelist.csp?AuditID="+AuditID+"&ToAuditID="+ToAuditID+"&SplitType="+SplitType+"&ARCIMID="+ARCIMID+"&OrdSetID="+OrdSetID
	parent.frames["TwoFeeList"].location.href=lnk;
	
}

function InitPage()
{
	
	//反选
	 ///全选
	$('#SelectFX').checkbox({
		onCheckChange:function(e,vaule){
			SelectFX_change(vaule);
			
			}
			
	});
	
	//全选登记  
	$('#SelectR').checkbox({
		onCheckChange:function(e,vaule){
			SelectR_clicked(vaule);
			
			}
			
	});
	
	//全选到达
	$('#SelectA').checkbox({
		onCheckChange:function(e,vaule){
			SelectA_clicked(vaule);
			
			}
			
	});
	

	var obj=document.getElementById("ARCIMDesc");
	if (obj) obj.onchange=ARCIMDesc_change;
	var obj=document.getElementById("txtItemSetDesc");
	if (obj) obj.onchange=txtItemSetDesc_change;
	
}

function ARCIMDesc_change()
{
	var obj;
	obj=document.getElementById("ARCIMID");
	if (obj) obj.value="";
}

function txtItemSetDesc_change()
{
	var obj;
	obj=document.getElementById("txtItemSetId");
	if (obj) obj.value="";
}


function SelectR_clicked(vaule)
{

	Select("R",vaule);
}
function SelectA_clicked(vaule)
{

	Select("A",vaule);
}
function SelectFX_change(vaule)
{

	Select("FX",vaule);
}

function Select(Type,vaule)
{
	
	var obj=parent.frames["TwoFeeList"];
	if (obj)
	{
		obj=obj.frames["LeftFeeList"];
		if (obj)
		{
			SelectApp(obj,Type,vaule);
		}
		
	}
}

function SelectApp(obj,Type,value)
{
	
	if (value==true) 
	{
		var SelectAll=1;
	}
	else
	{ 
		var SelectAll=0;
	}
	var RowIDs="";
	var objtbl =parent.frames["TwoFeeList"].frames["LeftFeeList"].$("#tDHCPEFeeListNew").datagrid('getRows');
    var rows=objtbl.length;
    
    for (var i=0;i<rows;i++)
    {
	  
	    var panel=parent.frames["TwoFeeList"].frames["LeftFeeList"].$("#tDHCPEFeeListNew").datagrid("getPanel");
	     var objCheck=panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+i+"] td[field="+"TChecked"+"] input")
	     if (Type!="FX")
	     {
		     if (objCheck.attr("type")=="checkbox") {
		     objCheck.prop("checked",0);
	     	}
	     }
    }
    
    for (var i=0;i<rows;i++)
    {
	  
	    var panel=parent.frames["TwoFeeList"].frames["LeftFeeList"].$("#tDHCPEFeeListNew").datagrid("getPanel");
	   var objCheck=panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+i+"] td[field="+"TChecked"+"] input")
     	var Status=objtbl[i].TItemName;
     	
     	if ((Type=="A")&&(Status=="到达")) {
	     	var objCheck=panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+i+"] td[field="+"TChecked"+"] input")
	    	if (objCheck.attr("type")=="checkbox") {
				objCheck.prop("checked",SelectAll);
	    	}
	     }
		if ((Type=="R")&&(Status=="登记")) {
				var objCheck=panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+i+"] td[field="+"TChecked"+"] input")
	    	if (objCheck.attr("type")=="checkbox") {
				objCheck.prop("checked",SelectAll);
			}
		}
		if (Type=="FX") {
				var objCheck=panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+i+"] td[field="+"TChecked"+"] input")
	    		if (objCheck.attr("type")=="checkbox") {
					if(objCheck.prop("checked")) {objCheck.prop("checked",0);}
					else{objCheck.prop("checked",1);}
			}
		}
		
		if (objCheck.prop("checked"))
		{
			var itemfeeid=objtbl[i].TRowId;
			var itemfeetype=objtbl[i].TFeeType;

			var itemfeeinfos="";
			if ((""!=itemfeeid)&&(""!=itemfeetype)) itemfeeinfos=itemfeeid+","+itemfeetype;
			if((""!=itemfeeid)&&(""==itemfeetype)) itemfeeinfos=itemfeeid;
			if (RowIDs=="") RowIDs=RowIDs+"^"		
			RowIDs=RowIDs+itemfeeinfos+"^";
		}
    
     
	}
	
}
function SelectItemSet(value)
{
	
	if (value=="") return false;
	var obj,AuditID="",ToAuditID="",OrdSetID="";
	obj=document.getElementById("txtItemSetId");
	if (obj) obj.value=value.split("^")[0];
	obj=document.getElementById("txtItemSetDesc");
	if (obj) obj.value=value.split("^")[1];
	
	var SplitType=getValueById("SplitType");
	var AuditID=getValueById("AuditID");
	var ToAuditID=getValueById("ToAuditID");
	 var OrdSetID=getValueById("txtItemSetId");
	//alert(OrdSetID+"^"+AuditID+"^"+ToAuditID+"^"+SplitType)
	parent.frames["TwoFeeList"].location.href="dhcpe2feelist.csp?AuditID="+AuditID+"&ToAuditID="+ToAuditID+"&SplitType="+SplitType+"&OrdSetID="+OrdSetID
}

function ARCIMSelect(value)
{
	if (value=="") return false;
	var obj,AuditID="",ToAuditID="",ARCIMID="";
	obj=document.getElementById("ARCIMID");
	if (obj) obj.value=value.split("^")[2];
	obj=document.getElementById("ARCIMDesc");
	if (obj) obj.value=value.split("^")[1];
	var SplitType=getValueById("SplitType");
	var AuditID=getValueById("AuditID");
	var ToAuditID=getValueById("ToAuditID");
	 var ARCIMID=getValueById("ARCIMID");
	//alert(ARCIMID+"^"+AuditID+"^"+ToAuditID+"^"+SplitType)
	parent.frames["TwoFeeList"].location.href="dhcpe2feelist.csp?AuditID="+AuditID+"&ToAuditID="+ToAuditID+"&SplitType="+SplitType+"&ARCIMID="+ARCIMID
} 


document.body.onload = BodyLoadHandler;