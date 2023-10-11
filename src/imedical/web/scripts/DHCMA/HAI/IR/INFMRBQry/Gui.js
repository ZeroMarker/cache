//页面Gui
var objScreen = new Object();
function InitMBRRepWin(){
	var obj = objScreen;
	var CheckFlg = 0;
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //审核权限
	}
	//评估状态
	$HUI.combobox("#cboStatus",{
		data:[
			{value:'0',text:$g('未评估')},
			{value:'1',text:$g('保存')},
			{value:'2',text:$g('提交')},
			{value:'3',text:$g('审核')},
			{value:'4',text:$g('删除')},
		],
		allowNull: true,
		valueField:'text',
		textField:'text'
	});
	// 日期初始赋值
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);	
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue', DateFrom);    // 日期初始赋值
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	//医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			if (CheckFlg!=1){  //非管理员权限科室不允许选择
				Common_ComboToLoc('cboLocation',rec.ID,"","I","E");
				$('#cboLocation').combobox('setValue',$.LOGON.LOCID);
				$('#cboLocation').combobox('setText',$.LOGON.LOCDESC);
				$('#cboLocation').combobox('disable');
			}else {
				Common_ComboToLoc('cboLocation',rec.ID,"","I","W");
			}
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);			
			obj.reloadgridApply(); //初始进行查询
		}
	});

	$HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:$g('送检日期'),selected:true},
			{value:'2',text:$g('报告日期')}
		],
		valueField:'value',
		textField:'text'
	})
	
	///加载病原体
	$HUI.combobox("#cboBacteria",{
		url:$URL+'?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=Array',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'BacDesc'
	});
	///加载多耐类型
	$HUI.combobox("#cboMRBBact",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleMRBSrv&QueryName=QryCRuleMRB&ResultSetType=Array',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'BTDesc'
	});
	///加载标本
	$HUI.combobox("#cboInfType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=IRInfType&aActive=1',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'DicDesc'
	});
	
	obj.gridMBRRep=$HUI.datagrid("#gridMBRRep", {
        fit:true,
        title:'多重耐药菌报告查询',
        toolbar:'#ToolBar',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
			{ field:"RepStatus",title:"评估状态",width:100,sortable:true,sorter:Sort_int,
				formatter:function(value,row,index){
					var ReportID=row["ID"];
					var RepStatus=row["RepStatus"];
					var EpisodeID=row["AdmID"];
					var LabRepID=row["xLabRepID"];
					return '<a href="#" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\',\'' + LabRepID + '\')">'+RepStatus+'</a>';
				}
			}, 
			{ field:"PapmiNo",title:"登记号",width:100,sortable:true,sorter:Sort_int},
			{ field:"MrNo",title:"病案号",width:100,sortable:true,sorter:Sort_int},
			{ field:"PatName",title:"姓名",width:100,sortable:true,sorter:Sort_int},		
			{ field:"AdmWardDesc",title:"就诊病区",width:180,sortable:true},
			{ field:"SpecDesc",title:"标本",width:100,sortable:true},
			{ field:"SubmissDate",title:"送检日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"ActDate",title:"报告日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"MRBDesc",title:"多耐类型",width:200,showTip:true,sortable:true},
			{ field:"link",title:"药敏结果",width:80,
				formatter:function(value,row,index){
					var ResultID=row["ResultID"];
					return '<a href="#" onclick="objScreen.OpenReslut(\'' + ResultID + '\')">'+$g("药敏结果")+'</a>';
				}
			},
			{ field:"InfTypeDesc",title:"感染类型",width:110,sortable:true},
			{ field:"InsulatDesc",title:"隔离方式",width:140,sortable:true},
			{ field:"ContactListDesc",title:"隔离措施",width:200,showTip:true,sortable:true},
			{ field:"PlaceListDesc",title:"感染病人安置",width:200,showTip:true,sortable:true},
			{ field:"UnitListDesc",title:"隔离单元设置",width:200,showTip:true,sortable:true},
			{ field:"TreatDesc",title:"感染病人诊疗",width:200,sortable:true},
			{ field:"EnvDesc",title:"环境物表处理",width:200,sortable:true},
			{ field:"ClothDesc",title:"用后被服处理",width:200,showTip:true,sortable:true},
			{ field:"VisitListDesc",title:"探视者管理",width:200,sortable:true},
			{ field:"EndListDesc",title:"终末消毒",width:200,sortable:true},
			{ field:"Sex",title:"性别",width:50,sortable:true},
			{ field:"Age",title:"年龄",width:80,sortable:true,sorter:Sort_int},
			{ field:"AdmDate",title:"入院日期",width:100,sortable:true,sorter:Sort_int},		
			{ field:"DischDate",title:"出院日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepDate",title:"填写日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepUser",title:"填写人",width:100,sortable:true},
			{ field:"RepLoc",title:"填写科室",width:150,sortable:true},
			{ field:"ZY",title:"操作明细",width:80,
			   formatter:function (value, row, index){
					var RepID=row["RepID"];
					return '<a href="#" onclick="objScreen.OpenMBRRepLog(\'' + RepID + '\')">'+$g("操作明细")+'</a>';
			   }
			}
		]],
		onSelect:function(rowIndex,rowData){
			obj.rowIndex=rowIndex;
        },
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
		}
    });
	//多耐报告操作明细
	obj.gridMBRRepLog=$('#gridMBRRepLog').datagrid({
        fit:true,
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
        columns: [[
			{ field:"SubID",title:"报告ID",width:80},
			{ field:"StatusDesc",title:"操作",width:120},
			{ field:"UpdateDate",title:"操作日期",width:120},
            { field:"UpdateTime",title:"操作时间",width:120},
            { field:"UpdateUserDesc",title:"操作人",width:120}
        ]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
	obj.gridIRDrugSen=$('#gridIRDrugSen').datagrid({
        fit:true,
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
	        { field:"AntDesc",title:"抗生素",width:400},
			{ field:"Sensitivity",title:"药敏结果",width:320,
				formatter: function(value,row,index){
					if (row.IsInt==1) {
						return value +'<div style="display:inline;margin-left:3px;background-color:red;color:#fff;border-radius:1px;font-size:10px;padding:2px;">'+$g("天")+'</div>';
					}else {
						return value;
					}						
				}		
			}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });

	InitMBRRepWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
