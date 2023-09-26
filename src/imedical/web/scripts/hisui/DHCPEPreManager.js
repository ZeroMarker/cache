
//����	DHCPEPreManager.js
//����  ԤԼ������Ϣ
//����	2018.10.18
//������  xy

function BodyLoadHandler() {
	
	var tableWidth = $("#tDHCPEPreManager").parent().width();
	//alert(tableWidth)
    var  tableWidth=930;
    $("#tDHCPEPreManager").datagrid("getPanel").panel('resize',{width:tableWidth});

	//����  
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
    //����   
   $("#BCreate").click(function() {	
		BCreate_click();		
        });
        
    //�滻   
   $("#BReplace").click(function() {	
		BReplace_click();		
        });
}

//���ӿɱ༭�б�
var editFlag="undefined";
var SelectedRow = -1;
var rowid=0;
$('#tDHCPEPreManager').datagrid({
	//�����н����༭
	onSelect: function (rowIndex, rowData) {	
		if (editFlag!="undefined") 
		{
	    	jQuery('#tDHCPEPreManager').datagrid('endEdit', editFlag);
	    	//EditRowColor();
	    	editFlag="undefined";
	    }
    },
})

//˫���п�ʼ�༭
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
		$.messager.alert("��ʾ","�滻���ڲ���Ϊ��","info");
		return false;
	}
	
	obj=document.getElementById("CreateClass");
	if(obj){encmeth=obj.value;}
	
	UserID=session['LOGON.USERID'];
	ret=cspRunServerMethod(encmeth,OldDate,NewDate,UserID);
	if(ret=="0"){
		alert("���Ƴɹ�");
	}
	window.location.reload();
}
function BReplace_click()
{
	var obj,OldDate="",NewDate="",encmeth="";
	OldDate=getValueById("DateStr");
	NewDate=getValueById("NewDate");
	if (NewDate==""){
		$.messager.alert("��ʾ","�滻���ڲ���Ϊ��","info");
		return false;
	}
	
	obj=document.getElementById("ReplaceClass");
	if(obj){encmeth=obj.value;}
	
	ret=cspRunServerMethod(encmeth,OldDate,NewDate);
	if(ret=="0"){
		alert("�滻�ɹ�");
	}
	window.location.reload();
}



document.body.onload = BodyLoadHandler;