//页面Gui
var objScreen = new Object();
function InitCtlBactResultWin(){
	var obj = objScreen;
	// 日期赋初始值
	var YearList = $cm ({									//初始化年(最近十年)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var MonthList = $cm ({									//初始化月+季度+全年
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth"
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth);
	$HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'送检日期',selected:true},
			{value:'2',text:'报告日期'}
		],
		valueField:'value',
		textField:'text'
	})
	
	//医院列表
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	obj.HospData = HospList.rows;
		
	//医院
    $HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){
			Common_ComboToLoc('cboLocation',rec.ID,"","I","W");
			Common_ComboToLoc('cboWard',rec.ID,"","I","W");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	
	///加载病原体
	$HUI.combobox("#cboBacteria",{
		url:$URL+'?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=Array',
		allowNull: false,       //再次点击取消选中
		valueField:'ID',
		textField:'BacDesc'
	});
	///加载多耐类型
	$HUI.combobox("#cboMRBBact",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleMRBSrv&QueryName=QryCRuleMRB&ResultSetType=Array',
		allowNull: false,       //再次点击取消选中
		valueField:'ID',
		textField:'BTDesc'
	});
	///加载标本
	$HUI.combobox("#cboLabSpec",{
		url:$URL+'?ClassName=DHCHAI.DPS.LabSpecSrv&QueryName=QryLabSpecimen&ResultSetType=Array&aActive=1',
		allowNull: false,       //再次点击取消选中
		valueField:'ID',
		textField:'SpecDesc'
	});
	$HUI.combobox("#cboMRBOutLabType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=MRBOutLabType',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'DicDesc'
	});
	//感染类型
	obj.cboInfType = Common_ComboDicID("cboInfType","IRInfType");
	
	obj.gridCtlResult=$('#gridCtlResult').datagrid({
        fit:true,
        title:'细菌检出结果查询',
        toolbar:'#ToolBar',
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
		sortOrder:'asc',
		remoteSort:false,
	    columns:[[
			{ field:"PapmiNo",title:"登记号",width:100,sortable:true},
			{ field:"MrNo",title:"病案号",width:100,sortable:true},
			{ field:"PatName",title:"姓名",width:100,sortable:true},
			{ field:"AdmWardDesc",title:"就诊病区",width:180,sortable:true},
			{ field:"LocDesc",title:"送检科室",width:150,sortable:true},
			{ field:"LabWardDesc",title:"送检病区",width:150,sortable:true},
			{ field:"ActDate",title:"送检日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepDate",title:"报告日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"Specimen",title:"标本",width:100,sortable:true},
			{ field:"Bacteria",title:"细菌",width:150,sortable:true},
			{ field:"MRBDesc",title:"多耐标记",width:200,showTip:true,sortable:true,
				formatter:function(value,row,index){
					 var MRBDesc2 = row["MRBDesc2"];
					 var MRBDesc  = row["MRBDesc"];
					 if (MRBDesc2!=""){
						return MRBDesc+","+MRBDesc2;
					}else{
						return MRBDesc;
					}
				}
			}, 
			{ field:"InfTypeDesc",title:"感染类型",width:120,sortable:true,
				formatter:function(value,row,index){
					var ResultID=row["ResultID"];
					var MRBOutLabType = row["MRBOutLabType"];
					var RowID=row["ID"];
					if (value!=""){
						return '<a href="#" style="color:#000" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType+ '\',\'' + RowID + '\')">'+value+'</a>';
					}else{
						return '<a href="#" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType + '\',\'' + RowID + '\')">标记</a>';
					}
				}
			},
			{ field:"expander",title:"摘要",width:80,
				formatter:function(value,row,index){					
					 return '<a href="#" onclick="objScreen.OpenMainView(\'' + row.AdmID + '\')">摘要</a>';
				}
			},
			{ field:"expander1",title:"电子病历",width:80,sortable:true,
				formatter:function(value,row,index){
					var EpisodeID = row["EpisodeID"];
					EpisodeID = EpisodeID.split("||")[1];
					return '<a href="#" onclick=objScreen.OpenEmrRecord(\''+EpisodeID+'\',\''+row.PatientID+'\')>病历浏览</a>';
				}
			},
			{ field:"expander2",title:"药敏结果",width:80,
				formatter:function(value,row,index){
					 var ResultID=row["ResultID"];
					return '<a href="#" onclick="objScreen.OpenReslut(\'' + ResultID + '\')">药敏结果</a>';
				}
			},					
		
			{ field:"Sex",title:"性别",width:50,sortable:true},
			{ field:"Age",title:"年龄",width:80,sortable:true},
			{ field:"AdmDate",title:"入院日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"DischDate",title:"出院日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"MRBOutLabType",title:"报告方式",width:120,sortable:true,sorter:Sort_int}
		]],
		rowStyler: function (index, row) {
        	if (row.InfTypeDesc == "HA(院内感染)") {
         		return 'color:red;';
        	}
        },
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
						return value +'<div style="display:inline;margin-left:3px;background-color:red;color:#fff;border-radius:3px;font-size:10px;padding:3px;width:20px;height:20px;font-weight: 600;">天</div>';
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

	InitCtlBactResultWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
