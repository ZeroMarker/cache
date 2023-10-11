//手术切口调查表[Gui]
var obj = new Object();
function InitRepSurvWin() {
	
	var cboEvItemFLList = $cm ({
			ClassName:"DHCHAI.BTS.DictionarySrv",
			QueryName:"QryDic",
			aTypeCode:"OperSurvStatus"
		},false);
	obj.EvItemFL = cboEvItemFLList.rows;
	$HUI.combobox("#cboSurvStatus",{
			valueField:'DicDesc',
			textField:'DicDesc',
			editable:true,
			data:obj.EvItemFL,
			onSelect:function(rec){
				
			},onLoadSuccess:function(data){

			}
		});
	//初始化数据
	//1.院区
	//医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
    $HUI.combobox("#cboHospital",{
		onSelect:function(rec){
			Common_ComboToLoc('cboLoction',rec.ID,"","I","E");
		}
	});
	//2.日期类型
	$HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'手术日期',selected:true},
			{value:'2',text:'填报日期'},
			{value:'3',text:'回访日期'},
			{value:'4',text:'入院日期'},
			{value:'5',text:'出院日期'}
		],
		valueField:'value',
		textField:'text'
	})
	//3.年-月-开始-结束日期
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
	//4.手术分类
	$HUI.combobox("#cboOperCat",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleOperCatSrv&QueryName=QryCRuleOperCat&ResultSetType=Array&aIsActive=1',
		allowNull: true,       //再次点击取消选中
		editable: true,
		multiple:true,        //全选/取消全选
		rowStyle:'checkbox',  //显示成勾选行形式
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField:'ID',
		textField:'OperCat'
	});
	//5.切口类型
	obj.cboIncision = Common_ComboDicID('cboIncision', 'CuteType');
	//7.回访结果
	obj.cboVisitResult = Common_ComboDicID('cboVisitResult', 'VisitResult');
	//8.1.手术分类编辑--分类
	//...
	//8.2.手术分类编辑--类别
	$HUI.combobox("#cboOperType",{
		data:[
			{value:'I',text:'手术'},
			{value:'D',text:'操作'}
		],
		valueField:'value',
		textField:'text'
	});
	//8.3.手术分类编辑--对相同名称手术分类
	$HUI.combobox("#cboIsAll",{
		data:[
			{value:'1',text:'是'},
			{value:'0',text:'否'}
		],
		valueField:'value',
		textField:'text'
	});
	
	//手术调查报告列表(前台加载)
    obj.gridINFOPSQry = $HUI.datagrid("#gridINFOPSQry", {
		fit:true,
        title:'手术切口调查表',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        singleSelect: true,
		rownumbers: false, //如果为true, 则显示一个行号列
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		pageSize: 50,
		pageList : [50,100,200,1000,10000],
        columns: [[
			{ field: 'RepStatus', title: '报告状态', width: 100,sortable:true,
			    formatter: function (value, row, index) {
                    if (value=="保存") {
			            return "<a href='#' style='white-space:normal;color:#229A06' onclick='obj.OpenOprReport(\"" + index + "\");'>" + value + "</a>";
			        }else if (value=="提交"){
			            return " <a href='#' style='white-space:normal; color:#58cf00' onclick='obj.OpenOprReport(\"" + index + "\");'>" + value + "</a>";
                    }else if (value=="审核"){
			            return " <a href='#' style='white-space:normal; color:#ffa200' onclick='obj.OpenOprReport(\"" + index + "\");'>" + value + "</a>";
                    }else if (value=="删除"){
			            return " <a href='#' style='white-space:normal; color:#bb0000' onclick='obj.OpenOprReport(\"" + index + "\");'>" + value + "</a>";
                    }else{
	                	return "<a href='#' style='white-space:normal; color:#00d5ee' onclick='obj.OpenOprReport(\"" + index + "\");'>新建</a>";
	                }
			    },
			    styler:function(value, row, index) {
	                if (value=="保存") {
	                    return 'background-color:#f8fff3';
	                }else if (value=="提交"){
			            return 'background-color:#E9ffe3';
                    }else if (value=="审核"){
			            return 'background-color:#ffeddf';
                    }else if (value=="删除"){
			            return 'background-color:#ffe2e2';
                    }else{
	                	return 'background-color:#dffcff';
	                }
			    }
			},
            { field: 'MrNo', title: '病案号', width: 100,sortable:true,sorter:Sort_int},
			{ field: 'PapmiNo', title: '登记号', width: 120,sortable:true,sorter:Sort_int},
			{ field: 'PatName', title: '姓名', width: 100 ,sortable:true},
			{ field: 'Sex', title: '性别', width: 60,sortable:true},
			{ field: 'Age', title: '年龄', width: 80,sortable:true,sorter:Sort_int},
            { field: 'AdmBed', title: '床号', width: 60,sortable:true,sorter:Sort_int},
            { field:"PAAdmDoc",title:"主管医生",width:90,sortable:true},
            { field:'link',title:"摘要",align:'center',width:60,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnAbstractMsg_Click(\''+row.EpisodeDr+'\')>摘要</a>';
				}
			},
            { field: 'OperDesc', title: '手术名称', width: 200,sortable:true},
			{ field: 'OperCatLists', title: '分类', width: 200,showTip:true,sortable:true},
            { field: 'OperLocDesc', title: '手术科室', width: 150,sortable:true},
            { field: 'OperDate', title: '手术日期', width: 100,sortable:true,sorter:Sort_int},
            { field: 'MapIncDicDesc', title: '切口等级', width: 80,sortable:true},
            { field: 'OperHour', title: '持续时间', width: 80,sortable:true,sorter:Sort_int},
            { field: 'OpertorName', title: '手术医生', width: 100,sortable:true,},
            { field: 'MapTypeDicDesc', title: '手术类型', width: 80,sortable:true},
            { field: 'MapASADicDesc', title: 'ASA评分', width: 80,sortable:true,sorter:Sort_int},
            { field: 'AdmDate', title: '入院时间', width: 100,sortable:true,sorter:Sort_int},
            { field: 'DischDate', title: '出院时间', width: 100,sortable:true,sorter:Sort_int},
            { field: 'InLocDate', title: '入科时间', width: 100,sortable:true,sorter:Sort_int},
            { field: 'OutLocDate', title: '出科时间', width: 100,sortable:true,sorter:Sort_int},
            { field: 'RepUser', title: '填报人', width:100,sortable:true},
            { field: 'RepDate', title: '填报日期', width: 100,sortable:true,sorter:Sort_int},
            { field: 'VistDate', title: '回访日期', width: 100,sortable:true,sorter:Sort_int},
            { field: 'VisitResult', title: '回访结果', width: 100,sortable:true}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
    InitRepSurvWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}


