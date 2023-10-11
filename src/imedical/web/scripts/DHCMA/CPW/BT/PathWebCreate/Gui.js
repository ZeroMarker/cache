//页面Gui
var obj = new Object();
function InitHISUIWin(){
	//var aHospID = session['LOGON.HOSPID']+"!!1";
	BTDesc=""
	$.parser.parse(); // 解析整个页面 
	var viewColumns = [];	
	obj.entityflag=true
	obj.Comentityflag=true
	obj.PathFormID=""
	obj.FormEpID=""
	obj.FormEpItemID=""
	obj.ItemCat=""
	editIndex=null
	if (typeof HISUIStyleCode === 'undefined'){
		$("#dataPng").attr("src","../images/no_data.png")
	}else{
		if (HISUIStyleCode=="lite"){
			$("#dataPng").attr("src","../images/no_data_lite.png")
			$('#addEntity').html("")
		}else{
			$("#dataPng").attr("src","../images/no_data.png")
		}
	}
	//引用模板路径
	$("#cboKbTmp").lookup({
		//url:$URL+"?ClassName=DHCMA.CPW.KBS.PathBaseSrv&QueryName=QryPBase&ResultSetType=array",
		url:$URL,
		panelWidth:450,
		mode:'remote',
		idField:'BTID',
		textField:'BTDesc',
		columns:[[
			{field:'BTDesc',title:'路径名称',width:180},  
			{field:'BTType',title:'专科类型',width:80},
			{field:'BTPubType',title:'发布类型',width:80},
			{field:'BTAdmType',title:'是否门诊',width:80},
			
		]],
		
		pagination:true,
		isCombo:true,
		minQueryLen:2,
		delay:'500',
		queryOnSameQueryString:true,
		queryParams:{ClassName:'DHCMA.CPW.KBS.PathBaseSrv',QueryName:'QryPBaseOrderYear',},
		onSelect:function(index,rowData){
			$("#txtKbTmp").val(rowData['BTID']);
			$('#txtDesc').val(rowData.BTDesc);	//路径名称
			//路径类型
			$('#cboType').combobox('setValue',rowData.BTTypeID);
			$('#cboType').combobox('setText',rowData.BTType);
			//就诊类型
			if (rowData.BTAdmType.indexOf("是")>-1){
				$('#cboIOType').combobox('setValue',"O");
			}else{
				$('#cboIOType').combobox('setValue',"I");
			}
			//手术病种
			if (rowData.BTIsOper=="是"){
				$('#IsOper').checkbox('setValue',true);
			}else{
				$('#IsOper').checkbox('setValue',false);
			}
			//是否有效
			if (rowData.BTIsActive=="是"){
				$('#IsActive').checkbox('setValue',true);
			}else{
				$('#IsActive').checkbox('setValue',false);
			}
		}			
	});
	//路径类型
	obj.cboType = $HUI.combobox('#cboType',{
		url: $URL,
		editable: true,
		defaultFilter:4,	
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathTypeSrv';
			param.QueryName = 'QryPathType';
			param.ResultSetType = 'array'
		},
		onShowPanel:function(){
			$(this).combobox('reload');	
		},
	});
	//病种路径
	obj.cboEntity = $HUI.combobox('#cboEntity', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		allowNull:true,
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		defaultFilter:4,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathEntitySrv';
			param.QueryName = 'QryPathEntity';
			param.aHospID 	= session['LOGON.HOSPID']+"!!"+1;
			param.aIsActive = 1;
			param.ResultSetType = 'array'
		},
		onShowPanel:function(){
			$(this).combobox('reload');	
		}
	})

	//病种路径
	obj.cboEntityType = $HUI.combobox('#cboEntityType',{
		url: $URL,
		editable: true,
		defaultFilter:4,	
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathTypeSrv';
			param.QueryName = 'QryPathType';
			param.ResultSetType = 'array'
		},
		onShowPanel:function(){
			$(this).combobox('reload');	
		},
	});
	//就诊类型
	obj.cboIOType = $HUI.combobox('#cboIOType', {
		valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'O',text:'门诊'},
			{id:'I',text:'住院'}
		]
	})
	//医嘱类型
	obj.cboYZType = $HUI.combobox('#cboYZType', {
		valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'B01',text:'长期医嘱'},
			{id:'B02',text:'临时医嘱'}
		]
	})
	$('#dd').panel({
	  onCollapse: function(){
		  obj.InitPathInfo();
		},
	 onExpand:function(){
		 obj.InitPathInfo();
		}
	});
	
	//阶段
	obj.ShowFromEp=function(PathFormID) {
		obj.cboFromEp = $HUI.combobox('#cboFromEp',{
			url: $URL+"?ClassName=DHCMA.CPW.BTS.PathWebCreateSrv&QueryName=QryPathFormEp&ResultSetType=array&aPathFormDr="+obj.PathFormID,
			editable: true,
			defaultFilter:4,	
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			valueField: 'ID',
			textField: 'EpDesc',
			onShowPanel:function(){
				//$(this).combobox('reload');	
			}
		});
	}
	obj.ShowFromYZEp=function(PathFormID) {
		obj.cboFromYZEp = $HUI.combobox('#cboFromYZEp',{
			url: $URL+"?ClassName=DHCMA.CPW.BTS.PathWebCreateSrv&QueryName=QryPathFormEp&ResultSetType=array&aPathFormDr="+obj.PathFormID,
			editable: true,
			defaultFilter:4,	
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			valueField: 'ID',
			textField: 'EpDesc',
			onShowPanel:function(){
				//$(this).combobox('reload');	
			}
		});
	}
	
	obj.EpItem=function(ItemCat) {
		if (ItemCat=="A") url=$URL+"?ClassName=DHCMA.CPW.KBS.ClinItemBaseSrv&QueryName=QryCIBase&ResultSetType=array"
		if (ItemCat=="C") url=$URL+"?ClassName=DHCMA.CPW.KBS.NurItemBaseSrv&QueryName=QryNIBase&ResultSetType=array"
		obj.cboEpItem = $HUI.combobox('#cboEpItem',{
			url: url,
			editable: true,
			defaultFilter:4,
			valueField: 'BTID',
			textField: 'BTDesc',
			onSelect:function(rowData){
				$('#EpItemGrid').datagrid('endEdit',editIndex);
				var row = $('#EpItemGrid').datagrid('getRows')[editIndex]
				row.BTEpItemDesc = rowData.BTDesc
				$('#EpItemGrid').datagrid('refreshRow',editIndex);
				$('#EpItemGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
			}
		});
	}
	obj.cboYZEpItem = $HUI.combobox('#cboYZEpItem',{
		url: $URL+"?ClassName=DHCMA.CPW.KBS.OrdItemBaseSrv&QueryName=QryOIBase&ResultSetType=array",
		editable: true,
		defaultFilter:4,
		valueField: 'BTID',
		textField: 'BTDesc',
		onSelect:function(rowData){
			$('#YZEpItemGrid').datagrid('endEdit',editIndex);
			var row = $('#YZEpItemGrid').datagrid('getRows')[editIndex]
			row.BTEpItemDesc = rowData.BTDesc
			row.KBEpItem=""
			$('#YZEpItemGrid').datagrid('refreshRow',editIndex);
			$('#YZEpItemGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
		}
	});

	//路径列表
	obj.pathWebList = $HUI.datagrid("#pathWebList",{
		url:$URL,
		fit:true,
		iconCls:'icon-resort',
		headerCls:'panel-header-gray',
		border:0,
		nowrap:false,
		fitColumns:true,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
			QueryName:"QryPathWebCreate",		
			aLocID: session['LOGON.CTLOCID']
		},		
		columns:[[					
			{field:'BTDesc',width:'242',title:"创建用户",
				formatter: function(value,row,index){
					return '<span title="创建人:'+row.BTCreUserDesc+'创建科室:'+row.BTCreLocDesc+'" class="hisui-tooltip grid-tips">'+value+'</span>';
				}
			}
		]],
		onLoadSuccess:function(data){
			 //$(".datagrid-header").removeClass();
			 $("#btnEditMast").linkbutton("disable");
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.pathWebList_onSelect();	
			}
		},
		singleSelect:true,
		pagination:false
	});
	//路径信息
	obj.InitPathInfo=function(){
		var viewColumns = [];	
		if(obj.PathFormID=="") return
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
			QueryName:"QryPathFormEp",
			aPathFormDr:obj.PathFormID,
			ResultSetType:"array",
		},function(rs){
			//动态添加列标题
			for (var i=0;i<rs.length;i++){
				var tmpObj = rs[i];
				viewColumns[i] = {field:"FLD-"+tmpObj.ID,title:tmpObj.EpDesc+'<div class="stepTitle" style="float:right"><span title="右移" style=\"padding-right:14px;cursor:pointer\" onclick=\"obj.RightMove(\'' + tmpObj.ID+ '\')\" class=\"icon-arrow-right">&nbsp;</span><span title="左移" style=\"padding:0 10px;cursor:pointer\" onclick=\"obj.LeftMove(\'' + tmpObj.ID+ '\')\" class=\"icon-arrow-left">&nbsp;</span><span title="编辑阶段信息" style=\"padding-right:14px;cursor:pointer\" onclick=\"obj.EditStep(\'' + tmpObj.ID+ '\')\" class=\"icon-edit">&nbsp;</span><span title="复制阶段" style=\"padding:0 10px;cursor:pointer\" onclick=\"obj.CopyStep(\'' + tmpObj.ID+ '\')\" class=\"icon-mtpaper-add">&nbsp;</span><span title="删除阶段" style=\"padding:0 10px;cursor:pointer\" onclick=\"obj.DelStep(\'' + tmpObj.ID+ '\')\" class=\"icon-no">&nbsp;</span></div>',width:'250'}
				//viewColumns[i] = {field:"FLD-"+tmpObj.ID,title:tmpObj.EpDesc+'<a id=#'+i+' onclick=\"obj.ClearNode(\'' + TreatRowID+ '\')\">2</a><span style=\"float:right;padding-right:14px;cursor:pointer\" class=\"icon-no">&nbsp;</span><span style=\"float:right;padding:0 20px;cursor:pointer\" class=\"icon-mtpaper-add">&nbsp;</span><span style=\"float:right;padding:0 10px;cursor:pointer\" class=\"icon-edit">&nbsp;</span>',width:'200'}
			}	
			$cm({
				ClassName:"DHCMA.CPW.BTS.PathWebCreateSrv",
				MethodName:"GetViewFormItems",
				aPathFormID:obj.PathFormID
			},function(rs){
				//获取表单视图
				obj.pathInfoInit = $HUI.datagrid("#pathInfoInit",{
					fit: true,
					//title:'路径名称：<span style=\"color:#1584D2\"><b>'+rs.name+'<b/></span>',
					headerCls:'panel-header-gray', //配置项使表格变成灰色
					pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
					rownumbers: false, //如果为true, 则显示一个行号列
					singleSelect: false,
					autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
					loadMsg:'数据加载中...',
					nowrap:false,
					//fitColumns:true,
					idField :'step',
					data:rs,
				    frozenColumns: [[
				    	{ field: 'step', title: '步骤<span title=\"新增阶段\"  onclick=\"obj.AddStep()\" style=\"float:right;padding-right:14px;cursor:pointer\" class=\"icon-add">&nbsp; </span>', width: 100,styler: function (value, row, index) {
	             			return 'background-color:#F4F6F5;';
	          			}
	          			},
			        ]],
					columns:[viewColumns],
					onBeforeLoad: function (param) {
			            var firstLoad = $(this).attr("firstLoad");
			            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
			            {
			                $(this).attr("firstLoad","true");
			                return false;
			            }
			            return true;
					},
					onLoadSuccess:function(){
						$(this).prev().find('div.datagrid-body').unbind('mouseover');
						//$(":input").attr("disabled", "disabled"); 
						$.parser.parse();
						$(".datagrid-header-row td").on('mouseenter',function(){
							$(".datagrid-header-over .stepTitle").toggle();
						}) 
						$(".datagrid-header-row td").on('mouseleave',function(){
							$(".datagrid-header-row .stepTitle").hide();
						});
						
						if (typeof HISUIStyleCode !== 'undefined'){
							if (HISUIStyleCode=="lite"){
								//$(".datagrid-wrap").attr("style","border-color:#red")
								$("#PathInit .hisui-panel").attr("style","border-color:#E2E2E2;")
							}
						}					
					},
					onClickRow: function (rowIndex, rowData) {
	    				$(this).datagrid('unselectRow', rowIndex);
					}
					,
					rowStyler: function(index,row){
						return 'background-color:#F7FBFF;';
					},
					loadFilter:function(data){
						for(var key in data.rows[2]){
							if(key=="step") continue; 
							data.rows[1][key]=data.rows[1][key]+"<br><div class=\"EpItem\" style=\'float:right;\'><span title=\'上移\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.TopMove('"+key.split('-')[1]+"','A')\" class=\'icon-arrow-top\'>&nbsp;</span><span title=\'下移\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.UnderMove('"+key.split('-')[1]+"','A')\" class=\'icon-arrow-bottom\'>&nbsp;</span><span title=\'编辑项目\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.ShowEpItem('"+key.split('-')[1]+"','A')\" class=\'icon-write-order\'>&nbsp;</span><span title=\'删除\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.DelteEpItem('"+key.split('-')[1]+"','A')\" class=\'icon-no\'>&nbsp;</span></div>";
							data.rows[2][key]=data.rows[2][key]+"<br><div class=\"EpItem\" style=\'float:right\'><span title=\'上移\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.TopMove('"+key.split('-')[1]+"','B')\" class=\'icon-arrow-top\'>&nbsp;</span><span title=\'下移\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.UnderMove('"+key.split('-')[1]+"','B')\" class=\'icon-arrow-bottom\'>&nbsp;</span><span title=\'编辑项目\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.ShowEpItem('"+key.split('-')[1]+"','B')\" class=\'icon-write-order\'>&nbsp;</span><span title=\'删除\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.DelteEpItem('"+key.split('-')[1]+"','B')\" class=\'icon-no\'>&nbsp;</span></div>";
							data.rows[3][key]=data.rows[3][key]+"<br><div class=\"EpItem\" style=\'float:right\'><span title=\'上移\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.TopMove('"+key.split('-')[1]+"','C')\" class=\'icon-arrow-top\'>&nbsp;</span><span title=\'下移\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.UnderMove('"+key.split('-')[1]+"','C')\" class=\'icon-arrow-bottom\'>&nbsp;</span><span title=\'编辑项目\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.ShowEpItem('"+key.split('-')[1]+"','C')\" class=\'icon-write-order\'>&nbsp;</span><span title=\'删除\' style=\'padding:0 10px;cursor:pointer\' onclick=\"obj.DelteEpItem('"+key.split('-')[1]+"','C')\" class=\'icon-no\'>&nbsp;</span></div>";
						}
					return data;		
				}
				});
			})
		})
	}
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
