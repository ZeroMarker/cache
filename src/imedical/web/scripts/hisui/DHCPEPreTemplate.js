//
//����	DHCPEPreTemplate.js
//����  �޶�ģ��
//����	2018.10.17
//������  xy

function BodyLoadHandler()
{
   //����  
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
    //����   
   $("#BCreate").click(function() {	
		BCreate_click();		
        });
	
	
}


//add by xy 2018-10-17
///hisui���죺���ӿɱ༭�б�
var editFlag="undefined";
var SelectedRow = -1;
var rowid=0;
$('#tDHCPEPreTemplate').datagrid({
	
	onSelect: function (rowIndex, rowData) {	//�����н����༭
		if (editFlag!="undefined") 
		{
	    	jQuery('#tDHCPEPreTemplate').datagrid('endEdit', editFlag);
	    	//EditRowColor();
	    	editFlag="undefined";
	    }
    },
})
//˫���п�ʼ�༭
function DblClickRowHandler(index,rowdata)	{	
	var Value1=$('#tDHCPEPreTemplate').datagrid('getColumnOption','NUM1');
	var Value2=$('#tDHCPEPreTemplate').datagrid('getColumnOption','NUM2');
	var Value3=$('#tDHCPEPreTemplate').datagrid('getColumnOption','NUM3');
	var Value4=$('#tDHCPEPreTemplate').datagrid('getColumnOption','NUM4');
	var Value5=$('#tDHCPEPreTemplate').datagrid('getColumnOption','NUM5');
	var Value6=$('#tDHCPEPreTemplate').datagrid('getColumnOption','NUM6');
	var Value0=$('#tDHCPEPreTemplate').datagrid('getColumnOption','NUM0');
	Value1.editor={type:'validatebox'};
	Value2.editor={type:'validatebox'};
	Value3.editor={type:'validatebox'};
	Value4.editor={type:'validatebox'};
	Value5.editor={type:'validatebox'};
	Value6.editor={type:'validatebox'};
	Value0.editor={type:'validatebox'};
	if (editFlag!="undefined")
	{
    	jQuery('#tDHCPEPreTemplate').datagrid('endEdit', editFlag);
    	editFlag="undefined"
	}
    jQuery('#tDHCPEPreTemplate').datagrid('beginEdit', index);
    editFlag =index;
}

function BUpdate_click()
{
	var obj,VIPID,Type,Num,OneStr="",Str="",LocID,UserID,rows=0,encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=session['LOGON.USERID'];
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	 
	var objtbl = $("#tDHCPEPreTemplate").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++){
		
		VIPID=objtbl[i].VIPID;
		OneStr=VIPID;
		Type=objtbl[i].Type;
		OneStr=OneStr+"^"+Type;
	    Num=objtbl[i].NUM1;		
		OneStr=OneStr+"^"+Num;
	    Num=objtbl[i].NUM2;		
		OneStr=OneStr+"^"+Num;
		Num=objtbl[i].NUM3;		
		OneStr=OneStr+"^"+Num;
		 Num=objtbl[i].NUM4;		
		OneStr=OneStr+"^"+Num;
	    Num=objtbl[i].NUM5;		
		OneStr=OneStr+"^"+Num;
		Num=objtbl[i].NUM6;		
		OneStr=OneStr+"^"+Num;
		Num=objtbl[i].NUM0;		
		OneStr=OneStr+"^"+Num;
		OneStr=OneStr+"^"+Num;
		if (Str==""){
			Str=OneStr;
		}else{
			Str=Str+"$"+OneStr;
		}
	}
	//alert(Str)
	var ret=cspRunServerMethod(encmeth,LocID,UserID,Str);
	if(ret==1) {
		$.messager.alert("��ʾ","����ɹ�","success");
		}
	else {
		$.messager.alert("��ʾ",ret,"info");
		}
}


function BCreate_click()
{
	var obj,LocID="",UserID="",StartDate="",EndDate="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=session['LOGON.USERID'];
	
	StartDate=getValueById("StartDate");
	EndDate=getValueById("EndDate");
	
	if ((StartDate=="")||(EndDate=="")){
		$.messager.alert("��ʾ","���ڲ���Ϊ��","info");
		return false;
	}

	var iStartDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",StartDate)
	var iEndDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EndDate)
	if(iStartDate>iEndDate){
		$.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ�������","info");
		return false;
	}

	obj=document.getElementById("CreateClass");
	if (obj) encmeth=obj.value;
	//alert(LocID+","+UserID+","+StartDate+","+EndDate)
	var ret=cspRunServerMethod(encmeth,LocID,UserID,StartDate,EndDate);
	if(ret=="OVER") {
		$.messager.alert("��ʾ","�����ɹ�","success");
	}
	else {
		$.messager.alert("��ʾ",ret,"info");
	}
}
document.body.onload = BodyLoadHandler;