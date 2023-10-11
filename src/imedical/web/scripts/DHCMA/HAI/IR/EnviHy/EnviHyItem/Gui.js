//页面Gui
var objScreen = new Object();
function InitEnviHyItemWin(){
	var obj = objScreen;
	obj.RecRowID1 = "";
	$.parser.parse(); // 解析整个页面
	
	//监测项目列表
	obj.gridEvItem = $HUI.datagrid("#gridEvItem", {
		fit:true,
		title: "环境卫生监测项目维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		fitColumns:true,
		autoRowHeight: false,
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.IRS.EnviHyItemSrv",
			QueryName:"QryEvItem"
		},
		columns:[[
			{field:'ID',title:'ID'},
			{field:'ItemTypeDesc',title:'项目分类',sortable:true},
			{field:'ItemDesc',title:'项目名称',sortable:true},
			{field:'SpecimenTypeDesc',title:'标本类型',sortable:true},
			{field:'Norm',title:'检测标准',sortable:true},
			{field:'NormMax',title:'中心值',sortable:true},
			{field:'NormMin',title:'周边值',sortable:true},
			{field:'SpecimenNum',title:'标本个数',sortable:true},
			{field:'CenterNum',title:'中心个数',sortable:true},
			{field:'SurroundNum',title:'周边个数',sortable:true},
			{field:'ReferToNum',title:'参照点个数',sortable:true},
			{field:'ForMula',title:'计算公式',sortable:true},
			{field:'Freq',title:'监测频率',sortable:true},
			{field:'Uom',title:'单位',sortable:true},
			{field:'EnvironmentCateDesc',title:'环境类别',sortable:true},			
			{field:'IsObjNullDesc',title:'申请时允许对象为空',sortable:true},
			{field:'IsSpecNumDesc',title:'申请时允许调整标本数量',sortable:true},
			{field:'EHEnterTypeDesc',title:'录入方式',sortable:true},
			{field:'LabItem',title:'检验项目',sortable:true},
			{field:'HospDesc',title:'关联院区',sortable:true,
				formatter:function(v){
					if (v=="") {
						return "全部院区";
					}else{
						return v
					}
				}
			},
			{field:'IsActDesc',title:'是否有效',sortable:true},
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1){
				obj.gridEvItem_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridEvItem_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			//增加清空关联表
			obj.RecRowID1="";
			obj.EvItemObjLoad();  //加载对象
		}
	});
	
	//项目类型
	obj.ItemType = Common_ComboDicID('cboItemType','EHItemType');		
	//标本类型
	obj.SpecimenType = Common_ComboDicID('cboSpecimenType','EHSpenType');		
	//环境类别
	obj.EnvironmentCate = Common_ComboDicID('cboEnvironmentCate','EHEnvironmentCate');		
	//录入方式
	obj.EHEnterType = Common_ComboDicID('txtEHEnterTypeDr','EHEnterType');

	//对象名称
	obj.ObjectDesc = $HUI.combobox('#ObjectDesc',{
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ID',
		textField: 'ObjectDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.IRS.EnviHyObjectSrv';
			param.QueryName = 'QryEvObject';
			param.ResultSetType = 'array'
		}
	});	
		
	//检验项目
	obj.cboLabItem = $HUI.combobox('#cboLabItem',{
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.DPS.LabInfTestSetSrv';
			param.QueryName = 'QryByType';
			param.aType = '1';
			param.ResultSetType = 'array'
		}
	});	
		
	obj.gridEvItemObj = $HUI.datagrid("#gridEvItemObj", {
		fit: true,
		title:'关联监测对象',
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		selectOnCheck:false,
	    checkOnSelect:false,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: true,
		loadMsg:'数据加载中...',
		url:$URL,
		queryParams:{
		    ClassName:"DHCHAI.IRS.EnviHyItemSrv",
			QueryName:"QryEvObjsByItem",
	    },
	    columns:[[
	    	{ field:'checked',checkbox:'true',align:'center',width:30},
			{field:'ObjDesc',title:'对象名称',width:'200',sortable:false},
		]],
		onBeforeLoad: function (param){
			//隐藏表头的checkbox
			$(".datagrid-header-check").html("");
			$(".datagrid-header-check").css("width","0");    //让对象名称顶格显示
			$(".datagrid-cell-c2-ObjDesc").css("width","300"); //隐藏对象名称那一格右侧的线
			
		},
		onCheck:function(rindex,rowData){
			var Parref = obj.RecRowID1
			var ID  = ''
			var ObjectID  = rowData.ObjID
			var aInputStr=Parref+"^^"+ObjectID+"^1"
			$m({
				ClassName:"DHCHAI.IR.EnviHyItemObj",
				MethodName:"Update",
				aInputStr:aInputStr
			},function(flg){
				if (parseInt(flg)<1) {
					$.messager.alert("错误提示","关联失败:"+flg,'info');
				}else{
					$.messager.popover({msg: '关联成功！',type:'success',timeout: 1000});
				}
			})
		},
		onUncheck:function(rindex,rowData){
			$m({
				ClassName:"DHCHAI.IR.EnviHyItemObj",
				MethodName:"DeleteById",
				aId:rowData.LinkID
			},function(flg){
				if (parseInt(flg)<0) {
					$.messager.alert("错误提示","撤销关联失败:"+flg,'info');
				}else{
					$.messager.popover({msg: '撤销关联成功！',type:'success',timeout: 1000});
				}
			})	
		},
		onLoadSuccess:function(data){
			var rLength=data.rows.length
			for (var i=0;i<rLength;i++) {
				var rowData=data.rows[i]
				if (rowData.LinkID!="") {
					if (rowData.aShowAll=="0"){
						$("#gridEvItemObj").datagrid("updateRow",{  
	        	       	index:i, //行索引  
	            	   	row:{  
	                		 	checked:0
	                	  }  
	 		 			});
						  $m({
							ClassName:"DHCHAI.IR.EnviHyItemObj",
							MethodName:"DeleteById",
							aId:rowData.LinkID
						})
	 		 		}else{ 
	 		 			$("#gridEvItemObj").datagrid("updateRow",{  
	        	       	index:i, //行索引  
	            	   	row:{  
	                		 	checked:1
	                	  	}  
	 		 			})
					}
				}
				
			}
		}
	});
	//关联院区
	$HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospitalToSelect&ResultSetType=Array',
		valueField:'ID',
		textField:'BTDesc'
	});
	$("#winEvItem .r-label").css("padding-left","6px")
	InitEnviHyItemWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}