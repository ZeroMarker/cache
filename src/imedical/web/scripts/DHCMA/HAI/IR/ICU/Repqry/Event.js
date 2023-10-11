var xls=null;
var xlBook=null;
var xlSheet=null;
//ICU调查登记表查询
function InitRepqryWinEvent(obj) {
    //初始化信息
    obj.LoadEvent = function () {
        obj.cboHospital = Common_ComboToSSHosp("cboHospital", $.LOGON.HOSPID);  //初始化医院
        obj.dtDateFrom = $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));  // 开始日期赋值
        obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));  // 结束日期赋值
    }
    //院区改变事件
    $HUI.combobox('#cboHospital', {
        onSelect: function () {
            obj.refreshICULoc();   //更新科室
        }
    });
    //开始日期改变事件
    $HUI.datebox('#dtDateFrom', {
        onChange: function (newValue, oldValue) {
	        if (!oldValue) return ;
            obj.refreshgridICULogs();  //刷新ICU登记表表格
        }
    });
    //结束日期改变事件
    $HUI.datebox('#dtDateTo', {
        onChange: function (newValue, oldValue) {
	        if (!oldValue) return;
            obj.refreshgridICULogs();  //刷新ICU登记表表格
        }
    });
    //病区改变事件
    $HUI.combobox('#cboLocal', {
        onSelect: function (rowData) {
            obj.IsNICU = rowData['IsNICU'];
            obj.refreshgridICULogs();  //刷新ICU登记表表格
        }
    });
    //插管类型改变事件
    $HUI.combobox('#cboTubeType', {
        onSelect: function () {
            obj.refreshgridICULogs();  //刷新ICU登记表表格
        }
    });
    //在-出院改变事件
    $HUI.radio("[name='chkAdmStatus']", {
        onChecked:function(e,value){
            obj.refreshgridICULogs();  //刷新ICU登记表表格
        }
    });
   	//ICU调查登记表导出事件
   	$('#btnICUExport').on('click', function () {
	    var rows = obj.gridICULogs.getRows();  //返回当前页的所有行
        if(rows.length==0){
	        $.messager.alert("错误","当前界面没有数据，无法导出!");
			return;
	    }
        $('#gridICULogs').datagrid('toExcel', 'ICU调查登记表.xls'); 
    });
    //ICU调查登记表检索框
    $('#searchICUbox').searchbox({
        searcher: function (value, name) {
            searchText($("#gridICULogs"), value);
        }
    });
	//ICU调查登记表导出报告明细数据
   	$('#btnExportRep').on('click', function () {
		var aHospID = $('#cboHospital').combobox('getValue');   //院区
        var aDateFrom = $('#dtDateFrom').datebox('getValue'); //开始时间
        var aDateTo = $('#dtDateTo').datebox('getValue');   //结束时间
        var aLocID = $('#cboLocal').combobox('getValue');       //ICU科室ID
        var aTubeType = $('#cboTubeType').combobox('getValue'); //插管类型
        var aAdmSatus = Common_RadioValue('chkAdmStatus');   //病人状态(住院/出院)
        if ((aDateFrom == "") || (aDateTo == "")) return;
        if (aDateFrom > aDateTo) {
            $.messager.alert("提示", "开始日期不能大于结束日期!", 'info');
            return;
        }
        if (aDateFrom > Common_GetDate(new Date())) {
            $.messager.alert("提示", "开始日期不能大于当前日期!", 'info');
            return;
        }
           
        var rows = $("#gridICULogs").datagrid('getRows');
		var reportIds = '';
		if (rows.length>0) {
			for (var row = 0; row < rows.length; row++){
				var rd = rows[row];
				if (!rd) continue;
				var repId = rd['RepID'];
				if (!repId) continue;
				if (reportIds != ''){
					reportIds += ',' + repId;
				} else {
					reportIds = repId;
				}
			}
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
        //调用导出报告
        var aDateType = $('#cboDateType').combobox('getValue');
        var aAdmSatus = Common_RadioValue('chkAdmStatus');   //病人状态(住院/出院)
		var Path = $m({
	        ClassName: "DHCHAI.IRS.ICURepExportSrv",
	        MethodName: "ExportFromServer",
	        aHospIDs:aHospID,
	        aDateFrom:aDateFrom,
	        aDateTo:aDateTo,
	        LocID:aLocID,
	        aDateType:aDateType,
	        aStatus: aAdmSatus,
	  		aRepIDs:reportIds,
	    }, false);
	    var url = Path;
			var form=$("<form id='download' class='hidden' method='post'></form>");
			form.attr("style","display:none");
			form.attr("target","");
			form.attr("method","post"); 
			form.attr("timeout",10000000); 
			form.attr("action",url);
			$("body").append(form);
			form.submit();//表单提交
        /*
        $HUI.datagrid("#gridExportXlsx",{
			fit: true,
	        //title: 'ICU调查登记表',
	        headerCls: 'panel-header-gray',
	        iconCls: 'icon-resort',
	        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
	        singleSelect: true,
	        nowrap: false,  //自动换行
	        loadMsg: '数据加载中...',
	        loading:true,
	        //是否是服务器对数据排序
			sortOrder:'asc',
			remoteSort:false,
			
	        pageSize: 500,
	        pageList: [100, 200, 500, 1000],
	        queryParams:{
				ClassName:"DHCHAI.IRS.INFICUPICCSrv",
				QueryName:"QryICUAdmByStatus",
				aSttDate: $('#dtDateFrom').datebox('getValue'),
	            aEndDate: $('#dtDateTo').datebox('getValue'),
	            aLocDr: $('#cboLocal').combobox('getValue'),
	            aStatus: Common_RadioValue('chkAdmStatus'),
	            aType: 3,
	            aIntuType: $('#cboTubeType').combobox('getValue'),
	            aEpisodeID: "",
				rows:10000
			},
	        columns: [[
				{ field: 'PapmiNo', title: '病案号', width: 100,sortable:true,sorter:Sort_int},
				{ field: 'PatientName', title: '姓名', width: 100,sortable:true,sorter:Sort_int},
				{ field: 'Sex', title: '性别', width: 50,sortable:true,sorter:Sort_int},
				{ field: 'Age', title: '年龄', width: 80,sortable:true,sorter:Sort_int},
				{ field: 'PAAdmDate', title: '入院日期', width: 120,sortable:true,sorter:Sort_int},
				{ field: 'PADischDate', title: '出院日期', width: 120, sortable: true,sortable:true,sorter:Sort_int},
	            { field: 'AdmWardDesc', title: '就诊科别', width: 120,sortable:true,sorter:Sort_int}
	        ]]
		});
        
		//$('#gridResult').datagrid('Export', {
		//替换为xlsx.full.min.js导出
		$('#gridExportXlsx').datagrid('exportByJsxlsx', {
			filename: 'ICU调查表明细数据',
			extension:'xlsx'
		});
		*/
		//PrintICUReport(hospId,startDate,endDate,aLocID);
    });
 	//导出民科事件
    $("#btnExportMK").on('click', function () {
		obj.btnExportInterface_click();	
	});
	
	obj.Layer_Save=function(aInputStr){
	        var InputStr=aInputStr;
	        
	        var flg = $m({
            ClassName: "DHCHAI.IRS.INFOPSSrv",
            MethodName: "SaveINFOPSStatus",
            aInputStr: InputStr,
            aSeparete: "^"
        }, false);
        return flg;
	}
    //导出民科事件
    //$('#btnExportMK').on('click', function (objBtn, objEvent, skipMapping) {
	  obj.btnExportInterface_click = function (objBtn, objEvent, skipMapping) {
	    //是否跳过字典对照检查（true：跳过）
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
	    //1.获取报告ID列表
	    var RepIDs=""; 
	    var length=$("#gridICULogs").datagrid('getChecked').length;
	    
		if (length>0) {
			var rows = $("#gridICULogs").datagrid('getChecked');
			for(var i=0;i<length;i++){
				var tmpRepID = rows[i]["RepID"];
				
				if (tmpRepID!="") {
						RepIDs +=  "^"+tmpRepID;
					} 
				}
		}
		RepIDs=RepIDs.substring(1);
		
		//2.导出报告
		if (RepIDs == "") {
			$.messager.alert("确认", "请选择需要导出的报告!", 'info');
			return;
		}
		
		var arrList = RepIDs.split("^");
		
		ExtTool.RunQuery(
			{
				ClassName : 'DHCHAI.MK.ExportToMKSrv',
				QueryName : 'QryValidateInfo',
				Arg1 : RepIDs,
				Arg2 : "^",
				Arg3 : "1",
				ArgCnt : 3
			},
			function(arryResult, skipMapping){
				if ((arryResult.length > 0) && (!skipMapping)) {
					//console.log(obj);
					var objFrm = new InitwinProblem(RepIDs, "^",obj);
					objFrm.winProblem.show();
				} else {
					ExtTool.prompt("文件路径", "请输入民科接口文件存放路径...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
								
								//创建进度条
								Ext.MessageBox.progress("接口文件", "开始导出民科接口文件...");
								var intTotalCnt = arrList.length;
								var flag = 0;
								var flag1= 0;
								for(var indRec = 0; indRec < intTotalCnt; indRec++)
								{
									var repID = arrList[indRec];
									
									var repInfo =$m({
										ClassName:"DHCHAI.MK.ExportToMKSrv",
										MethodName:"GetReportInfo",
										aReportID:repID
									},false)	//$.Tool.RunServerMethod("DHCHAI.MK.ExportToMKSrv","GetReportInfo",repID);
									if (repInfo.split("^").length==1){
										var flag1=1;
									    	
									    continue;
									}
									var PatName = repInfo.split("^")[0];
									var PatMrNo = repInfo.split("^")[1];
									var PatAdmDate = repInfo.split("^")[2];
									var strfolderName = PatMrNo + " " + PatName + " " + PatAdmDate;
									var strPath = ExportPath + "\\" + strfolderName;
									
									//var ret = objExportMinke.ExportMinkeData(repID, strPath,RepIDs);
									var ret = objExportMinke.ExportICUMinkeData(repID, strPath,RepIDs);
									
									if(ret==false){   //判断是否有未审核的报告
									
										flag++;
										continue;
									}
									//更新进度条
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "正在处理：" + PatMrNo + " " + PatName);
									/*
									var ret1 = obj.Layer_Save(repID+"^"+"8");
        	                        if (parseInt(ret1) > 0) {
	        	       
        	                       }
        	                       else {	        	
           	 	                       $.messager.alert("提示", "导出民科失败!", 'info');
            	                       return;
        	                      }	
        	                      */
								}
								
								//关闭进度条
								Ext.MessageBox.hide();
								if(flag1==1){
									$.messager.alert("提示", "出错了", 'info')
								    return;	
								}
								if(flag==intTotalCnt){   //先关闭进度条再提示
									layer.msg('未审核报告',{icon:2});
									return;	
								}
								obj.refreshgridICULogs();   //导出状态实时刷新
								ExtTool.confirm("接口文件", "共处理了" + intTotalCnt + "份患者ICU调查表信息,是否打开文件存放文件夹!", function(btn, txt) {
								if (btn == 'yes') {										
										if("undefined"===typeof EnableLocalWeb || 0===EnableLocalWeb){
											var WshShell = new ActiveXObject("WScript.Shell");										
											var oExec = WshShell.Exec("explorer.exe " + ExportPath);
										}
										else{
											var Str ="(function test(x){"
											Str += "var WshShell = new ActiveXObject('WScript.Shell');"+ '\n'
											var arryFolder = ExportPath.split("\\");
											var strPath = arryFolder[0];
											for(var i = 1; i < arryFolder.length; i ++){
												if(arryFolder[i] == "") continue;
												strPath += "\\\\" + arryFolder[i];		
											}
											Str += "var oExec = WshShell.Exec('"+"explorer.exe " +strPath+"');"+ '\n'
								            Str += "return 1;}());";
											CmdShell.notReturn =0;  
											var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
											
										}
									}
								});
							}
						},
						null,
						false,
						"D:\\民科感染报告接口文件"
					)
				}
			}
			,obj
			,skipMapping
		)
    };    //刷新ICU登记表
    obj.refreshgridICULogs = function () {
        $('#LayerICULogs').show();
        $('#LayerNICULogs').hide();

        var aHospID = $('#cboHospital').combobox('getValue');   //院区
        var aDateFrom = $('#dtDateFrom').datebox('getValue'); //开始时间
        var aDateTo = $('#dtDateTo').datebox('getValue');   //结束时间
        var aLocID = $('#cboLocal').combobox('getValue');       //ICU科室ID
        var aTubeType = $('#cboTubeType').combobox('getValue'); //插管类型
        var aAdmSatus = Common_RadioValue('chkAdmStatus');   //病人状态(住院/出院)
        var aDateType = $('#cboDateType').combobox('getValue');
        if ((aDateFrom == "") || (aDateTo == "")) return;
        if (aDateFrom > aDateTo) {
            $.messager.alert("提示", "开始日期不能大于结束日期!", 'info');
            return;
        }
        if (aDateFrom > Common_GetDate(new Date())) {
            $.messager.alert("提示", "开始日期不能大于当前日期!", 'info');
            return;
        }
        if (!aLocID) {
            $.messager.alert("提示", "科室不允许为空!", 'info');
            return;
        }
        $("#gridICULogs").datagrid("loading"); //加载中提示信息
        $cm({
            ClassName: 'DHCHAI.IRS.INFICUPICCSrv',
            QueryName: 'QryICUAdmByStatus',
            ResultSetType: "array",
            aSttDate: aDateFrom,
            aEndDate: aDateTo,
            aLocDr: aLocID,
            aStatus: aAdmSatus,
            aType: 3,
            aIntuType: aTubeType,
            aEpisodeID: EpisodeID,
            aDateType: aDateType,
            page: 1,
            rows: 200
        }, function (rs) {
            $('#gridICULogs').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
            $('#gridICULogs').datagrid('selectRow', obj.rowIndex);
        });
    }
    //打开
    obj.OpenICUReport = function (Paadm, RepID) {
        var LocDr = $('#cboLocal').combobox('getValue');
        //打开ICU调查登记表
       	var strUrl = "./dhcma.hai.ir.icu.report.csp?aLocDr=" + LocDr + "&aPaadm=" + Paadm + "&aRepID=" + RepID;
      	websys_showModal({
       		url: strUrl,
         	title: 'ICU调查表填写',
       		iconCls: 'icon-w-epr',
        	width: 1320,
        	height: '90%',
          	onBeforeClose: function () {
         		obj.refreshgridICULogs();
          	}
    	});
    }
    //刷新ICU病区
    obj.refreshICULoc = function () {
        var cbox = $HUI.combobox("#cboLocal", {
            url: $URL,
            editable: true,
            allowNull: true,
            defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
            valueField: 'ID',
            textField: 'LocDesc2',
            IsNICUField: 'IsNICU',
            onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
                param.ClassName = 'DHCHAI.BTS.LocationSrv';
                param.QueryName = 'QryICULoc';
                param.aHospIDs = $('#cboHospital').combobox('getValue');
                param.aLocID = "";
                param.aTypeID=1;
                param.ResultSetType = 'array';
            },
            onLoadSuccess: function () {   //初始加载赋值--默认第一个科室
                var data = $(this).combobox('getData');
                if (data != "") {
                    $(this).combobox('select', data[0]['ID']);
                }
            }
        });
    }
}

function PrintICUReport(hospId,startDate,endDate,aLocID){
	//调用报告模板
	var TemplatePath = $m({
        ClassName: "DHCMed.Service",
        MethodName: "GetTemplatePath",
    }, false);
	var FileName=TemplatePath+"DHCHAI.ICURepDtl.xlsx";
	
	try {
		xls = new ActiveXObject ("Excel.Application");
	}catch(e) {
		alert("创建Excel应用对象失败!");
		return;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	
    var flg = tkMakeServerCall('DHCHAI.IRS.ICURepExportSrv','PrintEHReport',"fillxlSheet,MergCells,DeleteRows",hospId,startDate,endDate,"");
    var fname = xls.Application.GetSaveAsFilename("ICU调查表明细数据","Excel Spreadsheets (*.xlsx), *.xlsx");
	//目录中存在重名的文件，在打开调试时选择“否”、“取消”会有报错
	//不知对选择“否”的处理如何写，暂时不处理
	try {
		xlBook.SaveAs(fname);
	}catch(e){
		return false;
	}
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);
}

function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			cells(cRow+i,cCol+j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;
		}
	}
	return cells;
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

//画单元格
function AddCells(objSheet,fRow,fCol,tRow,tCol,xTop,xLeft)
{
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle=1;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

//单元格合并
function MergCells(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).MergeCells =1;
}

//单元格对其
//-4130 左对齐
//-4131 右对齐
//-4108 居中对齐
function HorizontCells(objSheet,fRow,fCol,tRow,tCol,HorizontNum)
{
   objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment=HorizontNum;
}

//删除行
function DeleteRows(objSheet,row)
{
   objSheet.Rows(row).Delete;
}

//删除列
function DeleteCols(objSheet,col)
{
   objSheet.Columns(row).Delete;
}
