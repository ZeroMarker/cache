/// DHCPEOrderDetailRelateListCom.js
/// 创建时间		2006.03.24
/// 创建人		xuwm
/// 主要功能		显示医嘱项目的列表
/// 对应表		DHC_PE_OrderDetailRelate
/// 最后修改时间
/// 最后修改人	
var CurrentSel=0;

var targeURL="";
var URLParamName="";

var FStationRowId=""
function BodyLoadHandler() {

	iniForm();
	
}

function iniForm(){

	var objParam;
	
	
	objParam=document.getElementById('ParRef');
	if (""!=objParam.value) { FStationRowId=objParam.value; }
	
	objParam=document.getElementById('ListTargeURL');
	//if (""!=objParam.value) { targeURL=objParam.value; }
	if (objParam) { targeURL="DHCPEOrderDetailRelateCom"; }
	
	objParam=document.getElementById('ParamName');
	//if (""!=objParam.value) { URLParamName=objParam.value; }
	if (objParam) { URLParamName="ParRef"; }
	
	ShowCurRecord(1);
	}


function SearchOrderDetailCom_click(){

    var obj=document.getElementById("ARCIM_DR");
    if (obj){ var iARCIM_DR=obj.value; }
	
	obj=document.getElementById("ARCIM_DR");
	obj.value="";	    
    
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+targeURL
    	+"&"+URLParamName+"="+FStationRowId
		+"&"+"ParARCIMDR"+"="+iARCIM_DR
		;
    parent.frames[targeURL].location.href=lnk; 
}

//提取 选择记录函数中 选择显示部分 为了使在页面在载入时自动调取第一条记录 
//以便本页面的子页面有正确的传入参数
function ShowCurRecord(CurRecord) {
	var selectrow=CurRecord;
	var SelRowObj
	var obj	
	
	SelRowObj=document.getElementById('ODR_ARCIM_DR'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ARCIM_DR");
		obj.value=SelRowObj.value;
	}
	else {
		obj=document.getElementById("ARCIM_DR");
		obj.value="";	
	}

    SearchOrderDetailCom_click();
}

function SelectRowHandler()	{

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);	
	//var objtbl=document.getElementById('tDHCPEOrderDetailRelateListCom');
	
	if (objtbl) {
		var rows=objtbl.rows.length;
	}
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	//if (selectrow==CurrentSel)
	//{	    
	//    CurrentSel=0
	//    return;
	//	}

	CurrentSel=selectrow;
    ShowCurRecord(CurrentSel);


}
document.body.onload = BodyLoadHandler;
