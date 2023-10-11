/* 
 * FileName:	dhcinsu.InsuItemsDL.js
 * User:		ydc
 * Modify:      DingSH 20210430
 * Date:		2021-04-20
 * Function:	new医保目录下载
 * Description: 
*/
 var GV = {
	UPDATEDATAID : '',
	HOSPDR:session['LOGON.HOSPID'] ,
	USERID:session['LOGON.USERID'] ,
	HOSPID:session['LOGON.HOSPID']			//院区ID
}
 $(function () { 
 	window.onresize=function(){
    	location.reload();//页面进行刷新
 	} 
    //click事件
    init_mtClick();
    //加载目录类型
    initTitemType();
});
//清屏
function Clear(){
	setValueById('trtEDate',"");
	setValueById('trtSDate',"");
	setValueById('tVer',"");
	setValueById('tKeyWords',"");
	setValueById('tKeyType',"");
	setValueById('tHisBatch',"");
    //$('#insutrtdg').datagrid("loadData",{total:0,rows:[]});
    $('#insutrtdg').datagrid("load",{});
}
//加载目录类型
function initTitemType(){
	$("#titemType").combobox({
        valueField: 'Infno', textField: 'InfnoDesc', panelHeight: "auto",
        url:$URL+"?ClassName=INSU.MI.BL.InsuItemsDL&QueryName=QryListTypeByInfno&ResultSetType=array",
        //data:[{id:'',text:""}], 
		onBeforeLoad: function(param){
			param.Infno = "13*";
		} ,
		onLoadSuccess: function (data) {
		    if (data) {
   				$('#titemType').combobox('setValue',data[0].Infno);
			}
			//加载目录查询条件
		    initKeyTypes();
		    //加载版本号
		    initVers();
			//加载HIS下载批次
			inittHisBatchs();
			//加载表格列
		    initcolumns()
		},
		 onSelect: function (rec) {
			//$('#insutrtdg').datagrid("loadData",{total:0,rows:[]});
			initKeyTypes();
			initVers();
			inittHisBatchs();
			initcolumns();
			//QryInTarItems_Click();
			Clear();
　　  }  
    });
	}
//加载查询条件
function initKeyTypes() {
	
    //(0:按HIS创建日期查找,1:按HIS下载批次号查找,2:按目录编码(模糊查询)查找,药品商品名名称(模糊查询)查找)
    $("#tKeyType").combobox({
        valueField: 'id', textField: 'desc', panelHeight: "auto",
        //data:[{id:'',text:""}], 
		onShowPanel: function () {
			var url = $(this).combobox('options').url;
			if (!url){
				var url = $URL+"?ClassName=INSU.MI.BL.InsuItemsDL&QueryName=QryKeyTypeByInfno&ResultSetType=array";
				$(this).combobox('reload',url);
			}
		},
		onBeforeLoad: function(param){
			param.Infno = getValueById('titemType')//param.q;
		}
    });
    
}
//加载版本号
function initVers() {
    $("#tVer").combobox({
        valueField: 'Ver', textField: 'Ver', panelHeight: "auto",
        //data:[{id:'',text:""}], 
		onShowPanel: function () {
			var url = $(this).combobox('options').url;
			if (!url){
				var url = $URL+"?ClassName=INSU.MI.BL.InsuItemsDL&QueryName=QryVerByInfno&ResultSetType=array";
				$(this).combobox('reload',url);
			}
		},
		onBeforeLoad: function(param){
			param.Infno = getValueById('titemType')//param.q;
		}
    });
    
}
//加载HIS下载批次
function inittHisBatchs() {
    $("#tHisBatch").combobox({
        valueField: 'HisBatch', textField: 'HisBatch', panelHeight: "auto",
        //data:[{id:'',text:""}], 
		onShowPanel: function () {
			var url = $(this).combobox('options').url;
			if (!url){
				var url = $URL+"?ClassName=INSU.MI.BL.InsuItemsDL&QueryName=QryHisBatchByInfno&ResultSetType=array";
				$(this).combobox('reload',url);
			}
		},
		onBeforeLoad: function(param){
			param.Infno = getValueById('titemType')//param.q;
		}
    });
    
}

/**
*初始化click事件
*/
function init_mtClick() {
    //下载
    $("#btnTrtDL").click(MtQry_Click);
    //查询
    $("#btnSearch").click(QryInTarItems_Click);
    
}

//查询医保目录
function QryInTarItems_Click() {
	$('#insutrtdg').datagrid("loadData",{total:0,rows:[]});
    ///	 QryType:检索类型(0:按HIS创建日期查找,1:按HIS下载批次号查找,2:按目录编码(模糊查询)查找,药品商品名名称(模糊查询)查找)
    ///          StDate:开始日期
    ///          EndDate:结束日期
    ///          HospId:医院Id(CT_Hospital,不能为空)
    ///          HiType:医保类型(00A)
    ///          Code:目录编码(关键字)
    ///          Desc:药品商品名名称(关键字)
    ///          HisBatch:1:按HIS下载批次号查找
    ///          Ver:版本号

	//接口类型从界面选择
    var titemType=$('#titemType').combobox("getValue");
    if (titemType==""){
	    $.messager.alert("提示", "请选择目录类型!", 'info');
        return;  
	  }
	  
    var StartDate = getValueById('trtSDate');
    var EndDate = getValueById('trtEDate');
    var KeyType =getValueById('tKeyType')  //$('#tKeyType').combobox("getValue");
    //+20221208 HanZH
    if ((KeyType=="")&&((titemType=="1301")||(titemType=="1308"))){
        $.messager.alert("提示", "请选择查询条件!", 'info');
        return;
    }
    var KeyWords = $('#tKeyWords').val();
    var HOSPID = GV.HOSPID;
    if (HOSPID == "") { HOSPID = "2" }
    var tCode = ""
    var tDesc = ""
    var tHisBatch = getValueById('tHisBatch');
    if (KeyType == "2") {
        tCode = KeyWords
    }
    if ((KeyType == "3")||((KeyType == "4"))) {
        tDesc = KeyWords
    }
    var tVer = getValueById('tVer');

    $('#insutrtdg').datagrid('options').url = $URL;
	$.m({
		ClassName: "INSU.MI.BL.InsuItemsDL",
		MethodName: "GetQueryNameByInfno",
		type: "GET",
		Infno: titemType,
		HospDr: HOSPID
	}, function (rtn) {
        if (typeof rtn != "string")
         {
	       return ;
	     }
	     var rtnAry = rtn.split("^")
         if  (rtnAry[0]==-1){
	           return;
	         }
		$('#insutrtdg').datagrid('reload', {
        ClassName: rtnAry[0],
        QueryName: rtnAry[1],
        QryType: KeyType,
        StDate: StartDate,
        EndDate: EndDate,
        HospId: HOSPID,
        HiType: "00A",
        Code: tCode,
        Desc: tDesc,
        HisBatch: tHisBatch,
        Ver: tVer
    });
	});	
}
function initcolumns(){
	//接口类型从界面选择
    //var titemType=$('#titemType').combobox("getValue");
     var titemType=getValueById('titemType');
    if (titemType==""){
	    $.messager.alert("提示", "请选择目录类型!", 'info');
        return;  
	  }
	//后台获取列名
	var columns = new Array();//定义列数组
    var columnsStr=tkMakeServerCall("INSU.MI.BL.InsuItemsDL", "GetInsuColumnsByInfno", titemType);
    if(columnsStr.split("^")[0]==-1){
	     $.messager.alert("重要提示", columnsStr, 'error');
         return;  
	    }
    var columns=JSON.parse(columnsStr)
    initTable(columns);
}
 function initTable(columns) {
	 //初始化datagrid
    $HUI.datagrid("#insutrtdg", {
        fit: true,
        width: '100%',
        height: 800,
        border: false,
        singleSelect: true,
        rownumbers: true,
        data: [],
        columns:columns,
        columns: [
                    columns,//通过js动态生成。
                ],
        pageSize: 20,
        pagination: true,
        onClickRow: function (rowIndex, rowData) {

            //alert("rowData="+rowData.TRowid)   
            //InLocRowid=rowData.TRowid;
            //QryInLocRec();

        },
        onDblClickRow: function (rowIndex, rowData) {
            //InTarItemsEditClick(rowIndex);
        },
        onUnselect: function (rowIndex, rowData) {
            //alert(rowIndex+"-"+rowData.itemid)
        },
        onLoadSuccess: function (data) {
            var index = 0;

        }
    });
	 
 }


/**
*目录下载
*/
function MtQry_Click() {

    var ExpStr = ""  //医保类型^交易代码^HIS下载批次号所在列序号^是否全部下载^HIS批次号
    //接口类型从界面选择
    var Infno=getValueById('titemType');
    if (Infno==""){
	    $.messager.alert("提示", "请选择目录类型!", 'info');
        return;  
	  }
	var HisBatchIndex=tkMakeServerCall("INSU.MI.BL.InsuItemsDL", "GetHisBatchIndexByInfno", Infno);
    //DLAllFlag
    var DLAllFlag="0"
    //if ($('#DLAllFlag').checkbox('options').checked){DLAllFlag="1"} //IE不兼容
    if (getValueById('DLAllFlag')){ DLAllFlag="1" }                  //DingSH 20210924
    //HIS批次号
    var HisBatch=getValueById('tHisBatch');
    if(HisBatch==""){HisBatch="0"}; 	
    ExpStr="00A"+"^^"+Infno+"^"+HisBatchIndex+"^"+DLAllFlag+"^"+HisBatch
    var rtn=InsuPLDownload("0",GV.USERID,ExpStr); 
    if (!rtn) { return; }
    if (rtn != "-1") {
        $.messager.alert("提示", "目录下载完成!", 'info');
        return;
    }
}



//-----------------------------------------------
/*
* 将查询入参按照格式拼接
* DingSH 2021-01-11
* input: QryArgs,name,value
* output: name1=value1&name2=value2&...&namen=valuen
* --------------------end	
*/
function AddQryParam(QryArgs,name,value){
	return QryArgs+="&"+name+"="+value;
}
/*
 * 加载查询数据
 * data:[{},{}]格式
 */
function loadQryGrid(dgName,data){
	$('#'+dgName).datagrid({data:data,loadMsg:'数据加载中...',loadFilter: pagerFilter });
	/* 
	*这种方式也可以
	var data={total:RowsData.length,rows:RowsData}
	$('#'+dgName).datagrid({loadFilter: pagerFilter }).datagrid("loadData",data); 
	*/
}
/*
 * 根据字典类型和字典代码取描述
 */
function GetDicDescByCode(DicType,Code){
	var desc="";
	desc = tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd",DicType,Code,4);
	return desc !="" ? desc:Code;
	
}
