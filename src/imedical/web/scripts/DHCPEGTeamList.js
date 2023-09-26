/// DHCPEGTeamList.js

var CurrentSel=0;

var targeURL="";
var URLParamName="";

function BodyLoadHandler() {

	iniForm();
	
	}

function iniForm(){
	
	var obj; 

	//获取目标URL  
	obj=document.getElementById('TargetURLBox');
	targeURL=obj.value;
	
	//获取传递参数名	
	obj=document.getElementById('ParamNameBox');
	URLParamName=obj.value;
	
	//


	//显示第一条记录
	ShowCurRecord(1);
	
}

//调用子页面 编辑子项属性
function SearchOrderDetailCom_click(){

	var iRowId=document.getElementById("RowId").value;
	var iType="GT"
    var lnk="";
    var obj;
    var URLOtherParam="";
    
	obj=document.getElementById('OtherParamBox');
	URLOtherParam=obj.value;
	
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+targeURL
		+"&"+URLParamName+"="+iRowId
		+"&"+"sType"+"="+iType		
		; 

	
	if (""!=URLOtherParam) { lnk=lnk+URLOtherParam; }

	if (""!=lnk){
		parent.frames[targeURL].location.href=lnk;  
		
	} 
	 
}
//提取 选择记录函数中 选择显示部分 为了使在页面在载入时自动调取第
//一条记录 
//以便本页面的子页面有正确的传入参数
function ShowCurRecord(selectrow)	{
	
	var SelRowObj;
	var obj;
	
	//项目编号
	SelRowObj=document.getElementById('GT_RowId'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("RowId");
		obj.value=SelRowObj.value;
	}
	else {
		//没有列表项
		obj=document.getElementById("RowId");
		obj.value="";
	}

	//调用子页面 编辑子项属性
	SearchOrderDetailCom_click();
}
			
function SelectRowHandler()	{

	var eSrc=window.event.srcElement;

	var objtbl=document.getElementById('tDHCPEGTeamList');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
//	if (selectrow==CurrentSel)
//	{	    
//		CurrentSel=0
//		return;
//	}

	CurrentSel=selectrow;

    ShowCurRecord(CurrentSel);


}
document.body.onload = BodyLoadHandler;
