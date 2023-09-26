
//名称	DHCPEPreManager.js
//功能  预约管理信息
//创建	2018.10.18
//创建人  xy

function BodyLoadHandler() {
	
	var tableWidth = $("#tDHCPEPreManager").parent().width();
	//alert(tableWidth)
    var  tableWidth=930;
    $("#tDHCPEPreManager").datagrid("getPanel").panel('resize',{width:tableWidth});

	//保存  
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
    //复制   
   $("#BCreate").click(function() {	
		BCreate_click();		
        });
        
    //替换   
   $("#BReplace").click(function() {	
		BReplace_click();		
        });
}

//增加可编辑列表
var editFlag="undefined";
var SelectedRow = -1;
var rowid=0;
$('#tDHCPEPreManager').datagrid({
	//单击行结束编辑
	onSelect: function (rowIndex, rowData) {	
		if (editFlag!="undefined") 
		{
	    	jQuery('#tDHCPEPreManager').datagrid('endEdit', editFlag);
	    	//EditRowColor();
	    	editFlag="undefined";
	    }
    },
})

//双击行开始编辑
function DblClickRowHandler(index,rowdata)	{
		
	var Value1=$('#tDHCPEPreManager').datagrid('getColumnOption','TNum');
	Value1.editor={type:'validatebox'};
	if (editFlag!="undefined")
	{
    	jQuery('#tDHCPEPreManager').datagrid('endEdit', editFlag);
    	editFlag="undefined"
	}
    jQuery('#tDHCPEPreManager').datagrid('beginEdit', index);
    editFlag =index;
}

function BUpdate_click()
{
	var encmeth=""
	var objtbl = $("#tDHCPEPreManager").datagrid('getRows');
    var rows=objtbl.length;
    var obj=document.getElementById("UpdateMethod");
	if(obj){encmeth=obj.value;}
	
	for (var i=0;i<rows;i++)
	{
		var Type=objtbl[i].TType;
		var ID=objtbl[i].TID;
		var Num=objtbl[i].TNum;
		var GADMDesc=objtbl[i].TGADMDesc;
		ID=ID+"^"+Type;
		//alert(ID+"^"+Num+"^"+GADMDesc)
		var ret=cspRunServerMethod(encmeth,ID,Num,GADMDesc);
	}
	window.location.reload();
	
}
function BCreate_click()
{
	var obj,OldDate="",NewDate="",encmeth="",UserID="";
	OldDate=getValueById("DateStr");
	NewDate=getValueById("NewDate");
	if (NewDate==""){
		$.messager.alert("提示","替换日期不能为空","info");
		return false;
	}
	
	obj=document.getElementById("CreateClass");
	if(obj){encmeth=obj.value;}
	
	UserID=session['LOGON.USERID'];
	ret=cspRunServerMethod(encmeth,OldDate,NewDate,UserID);
	if(ret=="0"){
		alert("复制成功");
	}
	window.location.reload();
}
function BReplace_click()
{
	var obj,OldDate="",NewDate="",encmeth="";
	OldDate=getValueById("DateStr");
	NewDate=getValueById("NewDate");
	if (NewDate==""){
		$.messager.alert("提示","替换日期不能为空","info");
		return false;
	}
	
	obj=document.getElementById("ReplaceClass");
	if(obj){encmeth=obj.value;}
	
	ret=cspRunServerMethod(encmeth,OldDate,NewDate);
	if(ret=="0"){
		alert("替换成功");
	}
	window.location.reload();
}



document.body.onload = BodyLoadHandler;