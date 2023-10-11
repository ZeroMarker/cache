//页面Gui
var objScreen = new Object();
function InitCtlMonitorWin(){
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
	//医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			Common_ComboToLoc('cboLocation',rec.ID,"","I","W");
			Common_ComboToLoc('cboWard',rec.ID,"","I","W");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$HUI.combobox("#cboMRBOutLabType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=MRBOutLabType',
		allowNull: true,       //再次点击取消选中
		valueField:'ID',
		textField:'DicDesc'
	});
	$HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'送检日期',selected:true},
			{value:'2',text:'报告日期'}
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
	
	obj.gridCtlResult=$('#gridCtlResult').datagrid({
        fit:true,
        title:'多重耐药菌监控',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        nowrap: false,
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
			{ field:"AdmWardDesc",title:"就诊病区",width:150,sortable:true},
			{ field:"MRBDesc",title:"多耐类型",width:200,sortable:true,
				formatter: function(value,row,index){
					if (value){
					  	var strList = value.split(",");
					  	var len = strList.length;
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
				            var MRBDesc =strList[indx];
					         strRet +=MRBDesc+"</br>";  	
					  	}
					  	return strRet;
				  	}else {
						return "";
				  	}
				}
			}, 
			{ field:"link",title:"明细",width:80,sortable:true,
				formatter:function(value,row,index){
					 var EpisodeID=row["AdmID"];
					return '<a href="#" onclick="objScreen.openDetail(\'' + EpisodeID + '\')">明细</a>';
				}
			},
			{ field:"SpecBact",title:"标本 -> 细菌",width:200,sortable:true,
				formatter: function(value,row,index){
					if (value){
					  	var strList = value.split(",");
					  	var len = strList.length;
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
				            var SpecBact =strList[indx];
					         strRet +=SpecBact+"</br>";  	
					  	}
					  	return strRet;
				  	}else {
						return "";
				  	}
				}
			}, 
			{ field:"ZY",title:"摘要",width:80,
				formatter:function(value,row,index){					
					 return '<a href="#" onclick="objScreen.OpenMainView(\'' + row.AdmID + '\')">摘要</a>';
				}
			},
			{ field:"expander",title:"电子病历",width:80,
				formatter:function(value,row,index){
					var EpisodeID = row["EpisodeID"];
					EpisodeID = EpisodeID.split("||")[1];
					return '<a href="#" onclick=objScreen.OpenEmrRecord(\''+EpisodeID+'\',\''+row.PatientID+'\')>病历浏览</a>';
				}
			},
			{ field:"Sex",title:"性别",width:50,sortable:true},
			{ field:"Age",title:"年龄",width:80,sortable:false},
			{ field:"AdmDate",title:"入院日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"DischDate",title:"出院日期",width:100,sortable:true,sorter:Sort_int}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
		}
    });
	obj.gridBactDetail=$('#gridBactDetail').datagrid({
        fit:true,
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:false,
		nowrap:true,
		fitColumns: true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
	        { field:"ID",title:"序号",width:50},
			{ field:"Specimen",title:"标本",width:100,showTip:true},
			{ field:"Bacteria",title:"细菌",width:170,showTip:true},
			{ field:"MRBDesc",title:"多耐类型",width:200,showTip:true},
			{ field:"ActDate",title:"送检日期",width:100},
			{ field:"RepDate",title:"报告日期",width:100},
			{ field:"ActLocDesc",title:"科室",width:120,showTip:true},
			{ field:"ActUser",title:"医生",width:100}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });

	InitCtlMonitorWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
