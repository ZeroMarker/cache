//页面Gui
var objScreen = new Object();
function InitEnviHyApplyWin(){
	var obj = objScreen;
	obj.Report ='';
	obj.HospData = '';
	LogonHospID=$.LOGON.HOSPID;
	LogonUserID=$.LOGON.USERID;
	LogonLocID=$.LOGON.LOCID;
	LogonLocDesc=$.LOGON.LOCDESC;
	$.parser.parse(); // 解析EasyUI组件
  
    //查询条件
	if (tDHCMedMenuOper['Admin']!=1) {  //临床科室
	    obj.cboHospital = Common_ComboToSSHosp("cboHospital",LogonHospID);
	    obj.cboMonitorLoc = Common_ComboToLoc('cboMonitorLoc',LogonHospID);	
	    $('#cboHospital').combobox('disable');
	    $('#cboMonitorLoc').combobox('disable');
		$('#cboHospital').combobox('setValue',LogonHospID);
		$('#cboMonitorLoc').combobox('setValue',LogonLocID);
		$('#cboMonitorLoc').combobox('setText',LogonLocDesc);
	}else {
		var HospList = $cm ({
			ClassName:"DHCHAI.BTS.HospitalSrv",
			QueryName:"QryHospListByLogon",
			aLogonHospID:$.LOGON.HOSPID
		},false);
		obj.HospData = HospList.rows;
		
		$HUI.combobox("#cboHospital",{
			valueField:'ID',
			textField:'HospDesc',
			editable:false,
			data:obj.HospData,
			onSelect:function(rec){
				Common_ComboToLoc('cboMonitorLoc',rec.ID);
			},onLoadSuccess:function(data){
				// 院区默认选择
				$('#cboHospital').combobox('select',data[0].ID);
			}
		});
		$('#cboMonitorLoc').combobox({}); //联动表格需先初始化
		$('#cboHospital').combobox('enable');
	    $('#cboMonitorLoc').combobox('enable');
	}
	
	//默认日期类型
	$HUI.combobox("#DateType",{
		data:[{Id:'MonitorDate',text:'监测日期',selected:true},{Id:'ApplyDate',text:'申请日期'}],
		valueField:'Id',
		textField:'text'
	})
	
	//设置开始日期为当月1号
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('DateFrom',DateFrom);
    Common_SetValue('DateTo',DateTo);
	//监测项目
	$HUI.combobox("#cboEvItem", {
		valueField:'ID',
		textField:'ItemDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyItemSrv&QueryName=QryEvItem&ResultSetType=Array";
			$("#cboEvItem").combobox('reload',url);
		}
	});
	//报告状态
	obj.cboRepStatus = Common_ComboDicCode("cboRepStatus","EHRepStatus");	
      
    //表格
	obj.gridApply = $('#gridApply').datagrid({
        fit:true,
        title:'申请列表',
        toolbar:'#custtb',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        striped:true,
        singleSelect:false,
        selectOnCheck:true,
        checkOnSelect:true,
        fitColumns:true,
        loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
        queryParams:{
	        ClassName:'DHCHAI.IRS.EnviHyReportSrv',
	        QueryName:'QryEvReport',
	        aHospIDs:$("#cboHospital").combobox('getValue'),
	        aDateType:$("#DateType").combobox('getValue'),
	        aDateFrom:$("#DateFrom").datebox('getValue'),
	        aDateTo:$("#DateTo").datebox('getValue'),
	        aMonitorLoc:$("#cboMonitorLoc").combobox('getValue'),
	        aItemID:$("#cboEvItem").combobox('getValue'),
	        aStatusCode:$("#cboRepStatus").combobox('getValue'),
	        aFlowFlg:'',
	        aStandard:Common_CheckboxValue('checkStandard')
	    },
	    frozenColumns:[[{ field:'checked',checkbox:'true',align:'center',width:30}]],
        columns:[[
	        { field:"BarCode",title:"申请号",
	        	formatter:function(value,row,index){
		        	if (row.ReCheckSign == '1'){
						return '┏' + value+"&nbsp";
					} else if (row.ReCheckSign == '2'){
						return '┃' + value+"&nbsp";
					} else if (row.ReCheckSign == '3'){
						return '┗' + value+"&nbsp";
					} else {
						return value;
					}
		        }
	        },
			{ field:"EvItemDesc",title:"监测项目"},
			{ field:"ApplyLocDesc",title:"申请科室"},
			{ field:"ApplyDate",title:"申请日期"},
			{ field:"RepStatusDesc",title:"状态"},
			{ field:"EvItemObjDesc",title:"监测对象"},
			{ field:"MonitorLocDesc",title:"监测科室"},
			{ field:"MonitorDate",title:"监测日期"},
			{ field:"SpenTypeDesc",title:"标本类型"},
			{ field:"SpecimenNum",title:"标本数量"},
			{ field:"ApplyUserDesc",title:"申请人"},
			{ field:"Result",title:"监测结果",align:'center',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=objScreen.ShowResutlDtl('+row.ReportID+')><span class="icon icon-search" >&nbsp;&nbsp;&nbsp;&nbsp</span>查看</a>';
				}
			},
			{ field:"StandardDesc",title:"是否合格",
				styler: function(value,row,index){
					if (value=="不合格"){
						return 'background-color:#ffee00;color:red;';
					}else if (value=="合格"){
						return 'background-color:#76ff03;';
					}else{
						return 'background-color:#AAAAAA;';
						}
				},
				formatter:function(value,row,index){
					if (value=="") (value="无结果")
		        	if (row.ReCheckSign == '1'){
						return  '▼'+value;
					} else if (row.ReCheckSign == '2'){
						return '▼'+value;
					} else if (row.ReCheckSign == '3'){
						return  '►'+value;
					} else {
						return value;
					}
		        }
			},
			{ field:"ReCheck",title:"复检",
				formatter:function(value,row,index){
					if (row.StandardDesc=="不合格") {
					 	if (row.IsChecked=="1") {
						 	return "已复检"
					 	}else{
						 	return '<a href="#" onclick=objScreen.ReCheck('+JSON.stringify(row)+')><span class="icon icon-reset">&nbsp;&nbsp;&nbsp;&nbsp</span>复检</a>';
						}
					}else {
						if (row.ReCheckRepID>0) {
							return "复检单"
						}else{
							return 	''
						}
					}
				}
			}
        ]]
        ,rowStyler: function(index,row){
			if (row.ReCheckRepID>0){
				return 'background-color:#b2ebf2;'; 
			}
		}
        ,onBeforeLoad:function(param){
	        var StatusCode 	= $("#cboRepStatus").combobox('getValue');
	        if (ServerObj.StatusList.indexOf('6')>-1) {
		    	$('#btnColSpec').show();
		    	if (StatusCode=='2') {
			    	$("#btnColSpec").linkbutton("enable"); //查询状态为发放材料且有采集标本操作时，显示采集按钮
		    	}else {
		    		$("#btnColSpec").linkbutton("disable");
		    	}
		    }else{
			    $('#btnColSpec').hide();
			}
        },
        onSelect:function(rowIndex, rowData){
	        if ((rowData.RepStatusCode=='2')&&(ServerObj.StatusList.indexOf('6')>-1)) {
	       		$("#btnColSpec").linkbutton("enable");
	        }
        },
        onUnselect:function(rowIndex, rowData){
	        $("#btnColSpec").linkbutton("disable");
	        var StatusCode 	= $("#cboRepStatus").combobox('getValue');
	        if ((StatusCode!='2')&&(ServerObj.StatusList.indexOf('6')>-1)) {
		        var chkRows=$('#gridApply').datagrid('getChecked');
				for (var row = 0; row < chkRows.length; row++){
					var rd = chkRows[row];
					var RepStatusCode = rd['RepStatusCode'];
					if (RepStatusCode !='2') continue;
					$("#btnColSpec").linkbutton("enable");
				}
	        }
        },
		onDblClickRow:function(rowIndex,rowData){
			$("#gridApply").datagrid('clearSelections');  //取消历史选中	
			obj.Report=rowData;
			if ((tDHCMedMenuOper['Admin']!=1)&&(rowData.MonitorLocID!=LogonLocID)) {
				$.messager.popover({msg: '临床科室只能查看本科室申请',type:'error',timeout: 2000});
				return;	
			}
			obj.ApplyEdit();		
        }
	});
	
	/*申请单监测结果明细*/
	$('#ResultDetail').dialog({
		title: '监测结果',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true
	});
	
	obj.ApplyEdit = function(){
		//初始化
		$('#addA').show();	
		obj.execute =0;  //执行
		$('#cboAHospital').combobox('enable');
		$('#cboALoc').combobox('enable');
		$('#cboAEvItem').combobox('enable');
		$('#cboAEvObject').combobox('enable');
		websys_enable('txtCenterNum');
		websys_enable('txtSurroundNum');
		websys_enable('txtReferToNum');
		websys_enable('AEvObjectTxt');	
							
		$HUI.combobox("#cboAEvItem",{
			url:$URL+'?ClassName=DHCHAI.IRS.EnviHyItemSrv&QueryName=QryEvItem&ResultSetType=Array&aLocID='+$('#cboALoc').combobox('getValue'),
			valueField:'ID',
			textField:'ItemDesc',
			allowNull: true, 
			onSelect:function(row){
				var IsObjNull = row.IsObjNull;	//获取对象是否允许为空
				$('#AEvIsObjNull',IsObjNull);
				if (obj.execute==1) return;
				obj.LoadEvObjectSpen(row.ID);
			},onChange:function(newvalue,oldvalue){
				obj.LoadEvObjectSpen(newvalue);
			}
		});	
					
		if (obj.Report) {   //加载数据
			if (obj.Report.RepStatusDesc!="申请") {
				$('#addA').hide();				
				websys_disable('txtCenterNum');
				websys_disable('txtSurroundNum');
				websys_disable('txtReferToNum');
			}
			if (obj.Report.ReCheckRepID>0) {    //复检
				$('#cboAHospital').combobox('disable');
				$('#cboALoc').combobox('disable');
				$('#cboAEvItem').combobox('disable');
				$('#cboAEvObject').combobox('disable');
				websys_disable('AEvObjectTxt');
				websys_disable('txtCenterNum');
				websys_disable('txtSurroundNum');
				websys_disable('txtReferToNum');
			}
			$HUI.combobox("#cboAHospital",{
				valueField:'ID',
				textField:'HospDesc',
				editable:false,
				data:obj.HospData,
				onSelect:function(rec){
					Common_ComboToLoc('cboMonitorLoc',rec.ID);
				},onLoadSuccess:function(data){
					$('#cboAHospital').combobox('select',obj.Report.HospID);
				}
			});
			$('#cboALoc').combobox('setValue',obj.Report.MonitorLocID);
			$('#cboALoc').combobox('setText',obj.Report.MonitorLocDesc);
			$('#AMonitorDate').datebox('setValue',obj.Report.MonitorDate);
			$('#cboAEvItem').combobox('setValue',obj.Report.EvItemID);
			$('#cboAEvItem').combobox('setText',obj.Report.EvItemDesc);
			$('#cboAEvObject').combobox('setValue',obj.Report.EvItemObjID);	
			$('#cboAEvObject').combobox('setText',obj.Report.EvItemObjDesc.split("[")[0]);	
			$('#AEvObjectTxt').val(obj.Report.EHItemObjTxt);
			$('#txtCenterNum').val(obj.Report.RepCenterNum);
			$('#txtSurroundNum').val(obj.Report.RepSurroundNum);
			$('#txtReferToNum').val(obj.Report.ReferToNum);	
			$("#AEvIsObjNull").val(obj.Report.IsObjNull);

		}else {   //初始化
			if (tDHCMedMenuOper['Admin']!=1){ //非管理员，新建本科室申请
				obj.cboAHospital = Common_ComboToSSHosp("cboAHospital",LogonHospID);
		   		obj.cboALoc = Common_ComboToLoc('cboALoc',LogonHospID);	
			    $('#cboAHospital').combobox('disable');
			    $('#cboALoc').combobox('disable');
				$('#cboAHospital').combobox('setValue',LogonHospID);
				$('#cboALoc').combobox('setValue',LogonLocID);
				$('#cboALoc').combobox('setText',LogonLocDesc);							
			}else { 			//如果是管理员新建申请，科室与查询处监测科室一致
		    	$HUI.combobox("#cboAHospital",{
					valueField:'ID',
					textField:'HospDesc',
					editable:false,
					data:obj.HospData,
					onSelect:function(rec){
						Common_ComboToLoc('cboALoc',rec.ID);
					},onLoadSuccess:function(data){
						// 院区默认选择
						$('#cboAHospital').combobox('select',data[0].ID);
					}
				});
				$('#cboALoc').combobox({}); //联动表格需先初始化
				$('#cboALoc').combobox('setValue',$('#cboMonitorLoc').combobox('getValue'));
				$('#cboAHospital').combobox('enable');
		    	$('#cboALoc').combobox('enable');					
			}
			
			var AMonitorDate=Common_GetDate(new Date());
			$('#AMonitorDate').datebox('setValue',AMonitorDate);
			$('#cboAEvItem').combobox('setValue','');
			$('#cboAEvObject').combobox('setValue','');
			$('#txtCenterNum').val('');
			$('#txtSurroundNum').val('');
			$('#AEvObjectTxt').val('');
			$('#txtReferToNum').val('');
		}
		
		
		//申请单编辑modal
		$('#ApplyEdit').dialog({
			title: '监测申请单',
			iconCls:"icon-w-paper",
			headerCls:'panel-header-gray',
			modal: true
		});
		$HUI.dialog('#ApplyEdit').open();
	}
	
	obj.LoadEvObjectSpen = function(EvItemID){
		obj.execute =1;  //执行
		var EvObjectdata=$cm({
			ClassName:'DHCHAI.IRS.EnviHyItemSrv',
			QueryName:'QryEvObjsByItem',
			ResultSetType:'array',
			aParRef:EvItemID	
		},false);

		$HUI.combobox("#cboAEvObject",{
			data:EvObjectdata,
			valueField:'ObjID',
			textField:'ObjDesc',
			editable:false,
			onLoadSuccess:function(data){
				//只有一条记录默认加载
				if (data.length==1) {
					$('#cboAEvObject').combobox('select',data[0]['ObjID']);
				}
			}
		});
	
		var SpenNum = $m({
			ClassName:'DHCHAI.IR.EnviHyItem',
			MethodName:'GetSpenNumById',
			Id:EvItemID
		},false)
		var SpenNumArr=SpenNum.split("^");
		var CenterNum=SpenNumArr[1];
		var SurroundNum=SpenNumArr[2];
		var ReferToNum=SpenNumArr[3];
		var EHIsSpecNum=SpenNumArr[4];
		$('#txtCenterNum').val(CenterNum);
		$('#txtSurroundNum').val(SurroundNum);
		$('#txtReferToNum').val(ReferToNum);	
	
		if (EHIsSpecNum==0) { //如果不允许调整标本数量，则禁用录入框
			websys_disable('txtCenterNum');
			websys_disable('txtSurroundNum');
			websys_disable('txtReferToNum');
		}					

	}
	
	//复制历史申请单modal
	$('#CopyApply').dialog({
		title:'复制历史申请单',
		iconCls:"icon-w-paper",
		closed: true,
		closeable: true,
		modal: true,
		onBeforeOpen:function(){
			var monthlist=$m({
				ClassName:'DHCHAI.IRS.EnviHyReportSrv',
				MethodName:'GetLastMonth'	
			},false)
			var monthlist=eval(monthlist);
			$("#MonthList").keywords({
	            onClick:function(v){
		            $('#HisApplyList').datagrid('load',{
						ClassName:'DHCHAI.IRS.EnviHyReportSrv',
				        QueryName:'QryEvReportByMonth',
				        aHospIDs:$("#cboHospital").combobox('getValue'),
			        	aMonth:v.id
					});
					$('#HisApplyList').datagrid('unselectAll');
		        },
	            singleSelect:true,
	            items:[{
	                text:"历史申请单",
	                type:"chapter",
	                items:monthlist
	            }]
			})
          	$('#HisApplyList').datagrid({
		        fit:true,
		        headerCls:'panel-header-gray',
		        rownumbers:true,
		        striped:true,
		        singleSelect:false,
		        fitColumns:false,
		        url:$URL,
		        bodyCls:'no-border',
		        queryParams:{
			        ClassName:'DHCHAI.IRS.EnviHyReportSrv',
			        QueryName:'QryEvReportByMonth',
			        aHospIDs:$("#cboHospital").combobox('getValue'),
			        aMonth:monthlist[0].id,
			        aMonitorLoc:$("#cboMonitorLoc").combobox('getValue')
			    },
		        columns:[[
		        	{ field:'checked',checkbox:'true',align:'center',width:30},
		        	{ field:"MonitorLocDesc",title:"监测科室",width:160},
					{ field:"EvItemDesc",title:"监测项目",width:200},
					{ field:"EvItemObjDesc",title:"监测对象",width:80},
					{ field:"MonitorDate",title:"监测日期",width:100},
					{ field:"SpenTypeDesc",title:"标本类型",width:80},
					{ field:"SpecimenNum",title:"标本数量",width:70},
					{ field:"StandardDesc",title:"是否合格",width:70}
		        ]]  
          	})  
          	var DateNow=Common_GetDate(new Date());
    		$('#CAMonitorDate').datebox('setValue',DateNow); 
		}
	})
	InitEnviHyApplyWinEvent(obj);
	obj.loadEvents();
	return obj;
}
