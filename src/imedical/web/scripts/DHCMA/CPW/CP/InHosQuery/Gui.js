//页面Gui
var obj = new Object();		
function InitInHosQueryWin(){
    obj.LocID="";
    obj.Status="";
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp2("cboSSHosp",session['DHCMA.HOSPID'],"");
    //科室
	obj.cboLoc = $HUI.combobox("#cboLoc",{
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.Util.EPS.LocationSrv",
			param.QueryName="QryLocInfo",
			param.aHospID=$("#cboSSHosp").combobox('getValue'),
			param.aAdmType="I",
			param.aType="E",
			param.ResultSetType='array'	
		},
		editable: true,
		valueField: 'OID',
		textField: 'Desc',
		defaultFilter:4
	});
	var cboStatus = $HUI.combobox("#cboStatus",{
		valueField:'id',textField:'text',multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:false,
		data:[
			{id:'I',text:'入径'}
			,{id:'C',text:'完成'}
			,{id:'O',text:'出径'}
		],
		formatter:function(row){  
			var opts;
			if(row.selected==true){
				opts = "<input type='checkbox' checked='checked' id='r"+row.id+"' value='"+row.id+"' style='vertical-align:middle;margin-right: 3px;'>"+row.text;
			}else{
				opts = "<input type='checkbox' id='r"+row.id+"' value='"+row.id+"' style='vertical-align:middle;margin-right: 3px;'>"+row.text;
			}
			return opts;
		},
		onSelect:function(rec) {
			var objr =  document.getElementById("r"+rec.id);
			$(objr).prop('checked',true);
			obj.Status=obj.Status+"^"+rec.id;
		}
		,onUnselect:function(rec){
			var objr =  document.getElementById("r"+rec.id);
			$(objr).prop('checked',false);
			var subStr="^"+rec.id;
			obj.Status=obj.Status.replace(subStr,"");
		}
	});
	
   obj.GridInHosQuery = $HUI.datagrid("#GridInHosQuery",{
		fit: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		//nowrap:false,
		//fitColumns:true,
		/*url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.CPS.PathwaySrv",
			QueryName:"QryAdmInHos",	
			aLocID:Common_GetValue('cboLoc'),
			aHospID:Common_GetValue('cboSSHosp')
	    },*/
		columns:[[
			{field:'BTLocDesc',title:'科室名称',width:'250',align:'center'},
			{field:'BTCount',title:'在院人数',width:'150',align:'center'},
			{field:'BTCPWCount',title:'入径人数',width:'150',align:'center'},
			{field:'BTFormCount',title:'路径数',width:'100',align:'center'},
			{field:'BTCost',title:'费用超标人数',width:'150',align:'center'},
			{field:'BTAdmDays',title:'住院日超标人数',width:'150',align:'center'},
			{field:'BTIsVar',title:'变异数',width:'100',align:'center'},
			{field:'Link',title:'入径人数/在院人数',width:'250',align:'center',
				formatter: function(value,row,index){
					if ((row.BTCPWCount=="0")||(row.BTCount=="0")){
						var val="00.00%"
					}else{
						var val=row.BTCPWCount/row.BTCount*100
						var val=val.toFixed(2)+"%"
					}
					return val;
				}	
			}
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.GridInHosQuery_onDblClick(rowIndex,rowData);
			}
		},
		onLoadSuccess:function(data){
			if (typeof HISUIStyleCode !== 'undefined'){
				if (HISUIStyleCode=="lite"){
					$("#center .hisui-panel").attr("style","border-color:#E2E2E2;border-top:0;border-radius:0 0 4px 4px;")
				}
			}
		}
	});
	
	//明细列表
	obj.ShowInHosDetail=function(rowData){
		obj.GridInHosDetail = $HUI.datagrid("#GridInHosDetail",{
			fit: true,
			border:true,
			headerCls:'panel-header-gray',
			showGroup: true,
			groupField:'BTPathDesc',
			view: groupview,
			groupFormatter:function(value, rows){
				if(rows==undefined) return false;
				if (rowData.BTCount==0){
					var Peoper="00.00%"
				}else{
					var Peoper=rows.length/rowData.BTCount*100
					var Peoper=Peoper.toFixed(2)+"%"
				}
				if (rowData.BTCPWCount==0){
					var CPWPeoper="00.00%"
				}else{
					var CPWPeoper=rows.length/rowData.BTCPWCount*100
					var CPWPeoper=CPWPeoper.toFixed(2)+"%"
				}
				return value +': ' + rows.length + '<span style="margin:0 5px 0 10px">人数/在院人数:</span>' + Peoper + '<span style="margin:0 5px 0 10px">人数/入径人数:</span>' +CPWPeoper+'<span style="color:red;margin:0 5px 0 10px">参考费用:</span>'+rows[0].BTFormCost+'<span style="color:red;margin:0 5px 0 10px">参考住院日:</span>'+rows[0].BTFormDays;
			},  
			scrollbarSize: 0,
			checkOnSelect: false,
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'正在加载中...',
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			//pageSize: 50,
			//pageList : [50,100,200],
			url:$URL,
			queryParams:{
				ClassName:"DHCMA.CPW.CPS.PathwaySrv",
				QueryName:"QryAdmInHosDetail",
				aLocID:obj.LocID,
				aHospID:$("#cboSSHosp").combobox('getValue'),
				aStatus: obj.Status,
				page:1,
				rows:99999
			},
			columns:[[
				{field:'BTPatName',title:'姓名',width:'130',align:'center'},
				{field:'BTPatSex',title:'性别',width:'50',align:'center'},
				{field:'BTPatAge',title:'年龄',width:'80',align:'center'},
				{field:'Status',title:'路径状态',width:'80',align:'center'},
				{field:'BTAdmDocName',title:'医生',width:'80',align:'center'},
				{field:'BTAdmDate',title:'入院日期',width:'100',align:'center'},
				{field:'BTCPInDate',title:'入径日期',width:'100',align:'center'},
				{field:'BTEpisDesc',title:'所处步骤',width:'150',align:'center'},
				{field:'BTInCPWDate',title:'入径天数',width:'70',align:'center'},
				{field:'BTInHospDate',title:'在院天数',width:'70',align:'center'},
				{field:'BTPatCost',title:'费用',width:'100',align:'center'},
				{field:'BTDrugCost',title:'药费比例',width:'80',align:'center'},
				{field:'BTPerItem',title:'已实施项目比例',width:'120',align:'center'},
				{field:'BTVarDesc',title:'是否变异',width:'80',align:'center'}
			]],
			onLoadSuccess:function(data){
				if (typeof HISUIStyleCode !== 'undefined'){
					if (HISUIStyleCode=="lite"){
						$(".datagrid-wrap").attr("style","border-color:#E2E2E2")
					}
				}
			}
		})
	}
	InitInHosQueryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


