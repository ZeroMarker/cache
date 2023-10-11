/* 
 * FileName:	insuhilistquery.js
 * User:		Hanzh
 * Date:		2021-05-14
 * Function:	医保目录通用查询
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
    //回车事件
    $(".textbox").on('keyup',function(e){
		if (e.keyCode==13){
			QryInTarItems_Click();
		}
	});
});
//清屏
function Clear(){
	setValueById('Begndate',"");
	setValueById('Enddate',"");
	setValueById('HiListCode',"");
	setValueById('HilistName',"");
	setValueById('Wubi',"");
	setValueById('Pinyin',"");
	setValueById('ListType',"");
	setValueById('MedChrgitmType',"");
	setValueById('ChrgitmLv',"");
	setValueById('HilistUseType',"");
	setValueById('LmtCpndType',"");
	setValueById('LmtUsedFlag',"");
	setValueById('MedUseFlag',"");
	setValueById('MatnUsedFlag',"");
	setValueById('ValiFlag',"");
	setValueById('THisBatch',"");
    $('#hiinfolist').datagrid("loadData",{total:0,rows:[]});
}
//加载目录类型
function initTitemType(){
	$("#titemType").combobox({
        valueField: 'Infno', textField: 'InfnoDesc', panelHeight: "auto",
        url:$URL+"?ClassName=INSU.MI.BL.InsuHiListQuery&QueryName=QryListTypeByInfno&ResultSetType=array",
        //data:[{id:'',text:""}], 
		onBeforeLoad: function(param){
			param.Infno = "13*";
		} ,
		onLoadSuccess: function (data) {
		if (data) {
   				$('#titemType').combobox('setValue',data[0].Infno);
			}
			//加载HIS下载批次
			//inittHisBatchs();
		    //加载目录查询参数列表
		    initInput();
			//加载表格列
		    initcolumns();
		},
		 onSelect: function (rec) {
			//$('#hiinfolist').datagrid("loadData",{total:0,rows:[]});
			//inittHisBatchs();
			initInput();
			initcolumns();
			//QryInTarItems_Click();
			Clear();
　　  }  
    });
	}

//加载HIS下载批次
function inittHisBatchs() {
    $("#THisBatch").combobox({
        valueField: 'HisBatch', textField: 'HisBatch', panelHeight: "auto",
        //data:[{id:'',text:""}], 
		onShowPanel: function () {
			var url = $(this).combobox('options').url;
			if (!url){
				var url = $URL+"?ClassName=INSU.MI.BL.InsuHiListQuery&QueryName=QryHisBatchByInfno&ResultSetType=array";
				$(this).combobox('reload',url);
			}
		},
		onBeforeLoad: function(param){
			param.Infno = getValueById('titemType')//param.q;
			param.HospDr = HOSPID
			param.ExpStr = ""
		}
    });
    
}

//加载目录查询参数列表
function initInput() {
	//医疗收费项目类别
	var cbox = $HUI.combobox("#MedChrgitmType", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"01","Text":"床位费"},{"ID":"02","Text":"诊察费"},{"ID":"03","Text":"检查费"},{"ID":"04","Text":"化验费"},{"ID":"05","Text":"治疗费"},{"ID":"06","Text":"手术费"},{"ID":"07","Text":"护理费"},{"ID":"08","Text":"卫生材料费"},
				{"ID":"09","Text":"西药费"},{"ID":"10","Text":"中药饮片费"},{"ID":"11","Text":"中成药费"},{"ID":"12","Text":"一般诊疗费"},{"ID":"13","Text":"挂号费"},{"ID":"14","Text":"其他费"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 //收费项目等级
	var cbox = $HUI.combobox("#ChrgitmLv", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"甲类"},{"ID":"2","Text":"乙类"},{"ID":"3","Text":"自费"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 //目录类别
	var cbox = $HUI.combobox("#ListType", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"101","Text":"西药"},{"ID":"102","Text":"中成药"},{"ID":"103","Text":"中药饮片"},{"ID":"104","Text":"自制剂"},
				{"ID":"105","Text":"民族药"},{"ID":"201","Text":"服务项目"},{"ID":"301","Text":"医用材料"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 //限制使用标志
	var cbox = $HUI.combobox("#LmtUsedFlag", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"是"},{"ID":"0","Text":"否"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 //医疗使用标志
	var cbox = $HUI.combobox("#MedUseFlag", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"是"},{"ID":"0","Text":"否"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 //生育使用标志
	var cbox = $HUI.combobox("#MatnUsedFlag", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"生育可用"},{"ID":"0","Text":"生育不可用"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 
	 //限复方使用类型
	var cbox = $HUI.combobox("#LmtCpndType", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"单复方均可用"},{"ID":"2","Text":"限复方可用"},{"ID":"3","Text":"单复方不可用"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
	 
	  //有效标志
	var cbox = $HUI.combobox("#ValiFlag", {
			valueField: 'ID',
			textField: 'Text', 
			editable:false,
			data:[{"ID":"1","Text":"有效"},{"ID":"0","Text":"无效"}] ,
			filter: function(q, row){
			},onChange:function(newValue,OldValue){
			}
	 });
}

/**
*初始化click事件
*/
function init_mtClick() {
    //查询
    $("#btnSearch").click(QryInTarItems_Click);
    //接口目录查询
    $("#btnItfSearch").click(InsuHilistQuery_Click);
    
}
//目录查询
function InsuHilistQuery_Click() {
	var UserId=session['LOGON.GROUPID'];
	//'ExpStr=医保类型^交易代码^返回值格式标识()^返回值数据节点名^数据库连接串^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr="00A"+"^"+getValueById('titemType')+"^^^";
	var URIParams="";
	var pageopt = $('#hiinfolist').datagrid('getPager').data("pagination").options;        //其中,datagridID是datagrid的ID
    var pageNumber = pageopt.pageNumber;    //当前是第几页
    var pageSize= pageopt.pageSize; //每页显示多少条数据
    
	URIParams=AddURLParam(URIParams,"query_date",getValueById('querydate'));
	URIParams=AddURLParam(URIParams,"hilist_code",getValueById('hilistcode'));
	URIParams=AddURLParam(URIParams,"insu_admdvs",getValueById('insuadmdvs'));
	URIParams=AddURLParam(URIParams,"begndate",getValueById('begndate'));
	URIParams=AddURLParam(URIParams,"hilist_name",getValueById('hilistname'));
	URIParams=AddURLParam(URIParams,"wubi",getValueById('wubi'));
	URIParams=AddURLParam(URIParams,"pinyin",getValueById('pinyin'));
	URIParams=AddURLParam(URIParams,"med_chrgitm_type",getValueById('medchrgitmtype'));
	URIParams=AddURLParam(URIParams,"chrgitm_lv",getValueById('chrgitmlv'));
	URIParams=AddURLParam(URIParams,"lmt_used_flag",getValueById('lmtusedflag'));
	URIParams=AddURLParam(URIParams,"list_type",getValueById('listtype'));
	URIParams=AddURLParam(URIParams,"med_use_flag",getValueById('meduseflag'));
	URIParams=AddURLParam(URIParams,"matn_used_flag",getValueById('matnusedflag'));
	URIParams=AddURLParam(URIParams,"hilist_use_type",getValueById('hilistusetype'));
	URIParams=AddURLParam(URIParams,"lmt_cpnd_type",getValueById('lmtcpndtype'));
	URIParams=AddURLParam(URIParams,"vali_flag",getValueById('valiflag'));
	//URIParams=AddURLParam(URIParams,"updt_time",getValueById('updttime'));
	URIParams=AddURLParam(URIParams,"updt_time",getValueById('UpdataTime'));
	URIParams=AddURLParam(URIParams,"page_num",pageNumber); //2022-11-25 JINS
	URIParams=AddURLParam(URIParams,"page_size",pageSize);

	ExpStr=ExpStr+"^"+URIParams
	var rtn = InsuHilistQry(0,GV.USERID,ExpStr); //DHCINSUPort.js
	if(!rtn){return;}
	if(rtn.split("^")[0]!=0){
		$.messager.alert("提示","查询失败!rtn="+rtn, 'error')
		return;
	}
}

//查询医保目录
function QryInTarItems_Click() {
	$('#hiinfolist').datagrid("loadData",{total:0,rows:[]});
    ///          	StDate:开始日期
	/// 			EndDate:结束日期
	/// 			HospId:医院Id(CT_Hospital,不能为空)
	/// 			HiListCode:医保目录编码(关键字)
	/// 			HilistName:医保目录名称(关键字)
	/// 			Wubi:五笔助记码
	/// 			Pinyin:拼音助记码
	/// 	 		ListType:目录类别
	///         	MedChrgitmType:医疗收费项目类别
	///        		ChrgitmLv:收费项目等级
	///         	HilistUseType:医保目录使用类别
	/// 			LmtCpndType:限复方使用类型
	/// 	 		LmtUsedFlag:限制使用标志
	///         	MedUseFlag:医疗使用标志
	///         	MatnUsedFlag:生育使用标志
	///         	ValiFlag:有效标志
	/// 	 		THisBatch:下载批次

	//接口类型从界面选择

    var titemType=$('#titemType').combobox("getValue");
    if (titemType==""){
	    $.messager.alert("提示", "请选择查询类型!", 'info');
        return;  
	  }
	var t = new Date();//获取当前时间
	var year = t.getFullYear();//获取当前时间年份
	var month = t.getMonth()+1;//获取当前时间月份
	var day = t.getDate();//获取当前时间日
	var hour = t.getHours();
	var minute = t.getMinutes();
	var second = t.getSeconds();
	var nowTime = year+"/"+month+"/"+day+" "+hour+((minute<10)?":0":":")+minute+((second<10)?":0":":")
	+second;
	var UpTime=getValueById
	setValueById('QryTime',nowTime); 

    var StartDate = getValueById('Begndate');
    var EndDate = getValueById('Enddate');
    var HOSPID = GV.HOSPID;
    if (HOSPID == "") { HOSPID = "2" }
    
    var HiListCode = getValueById('HiListCode');
    var HilistName = getValueById('HilistName');
    var Wubi = getValueById('Wubi');
    var Pinyin = getValueById('Pinyin');
    var ListType = getValueById('ListType');
    var MedChrgitmType = getValueById('MedChrgitmType');
    var ChrgitmLv = getValueById('ChrgitmLv');
    var HilistUseType = getValueById('HilistUseType');
    
    var LmtCpndType = getValueById('LmtCpndType');
    var LmtUsedFlag = getValueById('LmtUsedFlag');
    var MedUseFlag = getValueById('MedUseFlag');
    var MatnUsedFlag = getValueById('MatnUsedFlag');
    
    var ValiFlag = getValueById('ValiFlag');
    var THisBatch = getValueById('THisBatch');

    $('#hiinfolist').datagrid('options').url = $URL;
	$.m({
		ClassName: "INSU.MI.BL.HiInfoListQRY",
		MethodName: "GetQueryNameByInfno",
		type: "GET",
		Infno: titemType
	}, function (rtn) {
        if (typeof rtn != "string")
         {
	       return ;
	     }
	     var rtnAry = rtn.split("^")
         if  (rtnAry[0]==-1){
	           return;
	         }
		$('#hiinfolist').datagrid('reload', {
        	ClassName: rtnAry[0],
        	QueryName: rtnAry[1],
        	StDate: StartDate,
        	EndDate: EndDate,
        	HospId: HOSPID,
        	HiListCode: HiListCode,
        	HilistName: HilistName,
        	Wubi: Wubi,
        	Pinyin: Pinyin,
        	ListType: ListType,
        	MedChrgitmType: MedChrgitmType,
        	ChrgitmLv: ChrgitmLv,
        	HilistUseType:HilistUseType,
       		LmtCpndType: LmtCpndType,
        	LmtUsedFlag: LmtUsedFlag,
        	MedUseFlag: MedUseFlag,
        	MatnUsedFlag: MatnUsedFlag,
        	ValiFlag: ValiFlag
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
    var columnsStr=tkMakeServerCall("INSU.MI.BL.InsuHiListQuery", "GetInsuColumnsByInfno", titemType);
    if(columnsStr.split("^")[0]==-1){
	     $.messager.alert("重要提示", columnsStr, 'error');
         return;  
	    }
    var columns=JSON.parse(columnsStr)
    initTable(columns);
}
 function initTable(columns) {
	 //初始化datagrid
    $HUI.datagrid("#hiinfolist", {
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

        },
//        onRowContextMenu: function (e, index, row) {
//			e.preventDefault();   //阻止浏览器默认的右键菜单弹出
//			//添加右键菜单
//			initRightMenu(e);
//			//判断是不是在同一条记录上右击如果是则不刷新支付方式和押金
//			if (row.pbrowid != getGlobalValue("BillID")) {
//				GV.BillList.selectRow(index);
//			}
//		}
    });
	 
 }
/**
 * 右键菜单
 */
function initRightMenu(e) {
	try {
		if (CV.RightMenus.length > 0) {
			var target = "rightyKey";
			var $target = $("#" + target);
			if (!$target.length) {
				$target = $("<div id=\"" + target + "\"></div>").appendTo("body");
				$target.menu();
				$.each(CV.RightMenus, function (index, item) {
					$target.menu("appendItem", {
						id: item.id,
						text: item.text,
						iconCls: item.iconCls,
						onclick: eval("(" + item.handler + ")")
					});
				});
			}
			$target.menu("show", {
				left: e.pageX,
				top: e.pageY
			});
		} 
	}catch (e) {
		$.messager.popover({msg: "创建右键菜单失败：" + e.message, type: "error"});
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
