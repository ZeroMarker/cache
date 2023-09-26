/// DHCPEOrderDetailListCom.js
/// 创建时间		2006.03.23
/// 创建人		xuwm
/// 主要功能		显示医嘱项目列表的列表 
/// 主要功能		以便编辑项目的属性
/// 适用范围		通用
/// 对应表		DHC_PE_OrderDetail
/// 最后修改时间
/// 最后修改人	
var CurrentSel=0;
var targeURL="";
var URLParamName="";
var FParRef=""
function BodyLoadHandler() {
	iniForm();
}

// *********************************************************************	  
function iniForm(){
	var obj; 
	var ltargeURL="";
	var lURLParamName="";
	
	

	//获取父站点 RowId
	obj=document.getElementById('ParRefBox');
	FParRef=obj.value;

	//获取目标URL  
	obj=document.getElementById('ListTargeURL');
	//ltargeURL=obj.value;
	//if (""!=ltargeURL) { targeURL=ltargeURL; }
	if(obj){targeURL="DHCPEODStandardCom"; }

	//获取传递参数名	
	obj=document.getElementById('ParamName');
	//lURLParamName=obj.value;	
	//if (""!=lURLParamName) { URLParamName=lURLParamName; }
	if(obj){URLParamName="ParRef";}
	
	//显示第一条记录
	//ShowCurRecord(1);
}
//调用子页面 编辑子项属性
function SearchOrderDetailCom_click(){
	
	var iRowId='';
	var iType='';
	var iDesc='';
	
	var obj;
	
	obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value ; }
	
    obj=document.getElementById("Type");
    if (obj) { iType=obj.value ; }
    
    obj=document.getElementById("Desc");
	if (obj) { iDesc=obj.value ; }
	
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+targeURL
		+"&"+URLParamName+"="+iRowId
		+"&"+URLParamName+"Name="+iDesc
		+"&"+"OrderDetailType"+"="+iType
		; 
		//alert(lnk)
	if (""!=lnk){
		parent.frames[targeURL].location.href=lnk;  
	}	
}
//提取 选择记录函数中 选择显示部分 为了使在页面在载入时自动调取第一条记录 
//以便本页面的子页面有正确的传入参数
function ShowCurRecord(selectrow)	{
	
	var SelRowObj;
	var obj;

	//项目编号
	SelRowObj=document.getElementById('OD_RowId'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("RowId");
		obj.value=SelRowObj.value;
	}

	//项目类型
	SelRowObj=document.getElementById('OD_Type'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Type");	
		obj.value=SelRowObj.value;   
	}

	//项目类型
	SelRowObj=document.getElementById('OD_Desc'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Desc");
		obj.value=SelRowObj.innerText;
	}

	//调用子页面 编辑子项属性
	SearchOrderDetailCom_click();
}
			
function SelectRowHandler()	{

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);		
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
