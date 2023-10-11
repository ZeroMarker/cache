var editRow=0;
var editcomRow=0;
var editdosRow=0;
$(function(){ 

	initCombobox();
	initButton();
	initDrugInfoList();

})

///初始化combobox
function initCombobox()
{
	  var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
	  $HUI.combobox("#hosp",{
	 		url:uniturl,
			valueField:'value',
			textField:'text',
			panelHeight:"260",
			mode:'remote',
			onSelect:function(ret){
										//query();
			 }
	 	})
		 	
		 	
		var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryDrugList"  
		
		$HUI.combobox("#drugname",{
		 		url:uniturl+"&flag=1",
				valueField:'value',
				textField:'text',
				panelHeight:"260",
				mode:'remote',
				onSelect:function(ret){
					query();
			 }
	 	})
		 	
	 	$HUI.combobox("#genename",{
				url:uniturl+"&flag=2",
				valueField:'value',
				textField:'text',
				panelHeight:"260",
				mode:'remote',
				onSelect:function(ret){
					query();

			 }
	 	})
		 	
	 	$HUI.combobox("#ingredient",{
				url:uniturl+"&flag=3",
				valueField:'value',
				textField:'text',
				panelHeight:"260",
				mode:'remote',
				onSelect:function(ret){
						query();
			 }
	 	})
		 	
		 	
	 	$HUI.combobox("#emptyval",{
				valueField:'value',
				textField:'text',
				panelHeight:"260",
				mode:'remote',
				data:[
						{value:'Gene',text:'通用名为空'},
						{value:'Comp',text:'成分为空'},
						{value:'Dosa',text:'剂型为空'},
						{value:'Cat',text:'分类为空'},
						{value:'Drug',text:'药品为空'},
						{value:'Rule',text:'规则为空'},
						{value:'FormGen',text:'带剂型通用名为空'},
						{value:'Manuf',text:'厂家为空'},
						{value:'Equunit',text:'等效单位为空'},
						{value:'Noninunit',text:'等效单位中不包含规则中单位'},
						{value:'Verrule',text:'需核查规则'},
						{value:'UsaDos',text:'用法用量中存在的溶媒溶液'},
						{value:'Indicat',text:'适应症为空'},
						{value:'Usage',text:'用法用量为空'},
						{value:'PhaTox',text:'药理毒理为空'},
						{value:'PhaKin',text:'药代动力学为空'},
						{value:'CancelRel',text:'规则未发布'}
						
				],
				onSelect:function(ret){
						query();
			 }
	 	})
		 	
	 	///分类
	 	$HUI.combotree("#drugcat",{
			url:$URL+'?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref=106',
			editable:true,
			onSelect:function(node){			
				query();
			}
		})
	 	
}

///初始化按钮
function initButton()
{
	 	$("#find").bind("click",query);
	 	$("#reset").bind("click",reset);
	 	$("#geninsert").bind("click",geninsert);
	 	$("#gensave").bind("click",gensave);
	 	$("#compinsert").bind("click",compinsert);
	 	$("#compsave").bind("click",compsave);
	 	$("#dosainsert").bind("click",dosainsert);
	 	$("#dosasave").bind("click",dosasave);
	 	
}

///药品列表
function initDrugInfoList()
{
		var columns=[[
			{field:'ck',title:'操作',width:60,formatter:SetCellOperation},
			{field:'drugId',title:'drugId',hidden:false},
	        {field:'drug',title:'药品名称',width:320},
	        {field:'hisCode',title:'HIS药品代码',width:120},
	        {field:'extDesc',title:'HIS药品描述',width:220},
	        {field:'rule',title:'是否存在规则',width:120},
	        {field:'generFormName',title:'带剂型通用名',width:120},
	        {field:'generName',title:'通用名',width:120},
	        {field:'drugComp',title:'成分',width:120},
	        {field:'drugDosa',title:'剂型',width:100},
	        {field:'drugManuf',title:'生产厂家',width:100},
	        {field:'equunit',title:'等效单位',width:100},
	        {field:'hisequunit',title:'HIS等效单位',width:100},
	        {field:'addEqUnitBtn',title:'导入等效单位',width:100,formatter:addEqUnitOperation,align:"center"},
	        {field:'errruleNum',title:'需核查规则',width:100},
	        {field:'nounitinlib',title:'等效单位未维护的单位',width:150},
	        {field:'drugCat',title:'药学分类',width:300},
	        {field:'copyCat',title:'复制分类',width:60,formatter:repliccat},
	        {field:'sameGenDrug',title:'相同通用名的药品分类',width:450},
	        {field:'usadosRule',title:'用法用量中存在溶媒溶液',width:250},
	        {field:'diseList',title:'疾病',width:60,hidden:false,formatter:linkdiseInfo},
	        {field:'drugCatId',title:'drugCatId',width:60,hidden:true}
		]];
		var check="0";
		if($("#manurep").get(0).checked) {
			var check="1"
  		}else{
	   		var check="0"
  	    }
		var params = $HUI.combobox("#hosp").getValue() +"^"+ $HUI.combobox("#drugname").getText() +"^"+ $HUI.combobox("#genename").getText() +"^"+ $HUI.combobox("#ingredient").getText() +"^"+ $HUI.combobox("#emptyval").getValue()+"^"+check;
		params = params +"^^"+ $("#drugcat").combotree("getText");
		///  定义datagrid  
		var option = {
					nowrap:false,
					rownumbers : true,
					singleSelect : true,
				    onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
				    
			     },
			     onClickRow:function(rowIndex, rowData){	
			        
				 },
				 onLoadSuccess:function(data){
					 	var params = $HUI.combobox("#hosp").getValue() +"^"+  $("#drugcat").combotree("getText");					 	
					 	/*
		                var ret = serverCall("web.DHCCKBCalculateval","QueryCatDisNum",{"params":params});
		                $("#ruleIndnum").html(ret.split("^")[0]);
		                $("#ruleContnum").html(ret.split("^")[1]);
		                $("#allcatnum").html(ret.split("^")[2]);
		                var ruleInList = ret.split("^")[3];
		                $("#ruleIndnum").attr("data",ruleInList)
		                var ruleconList = ret.split("^")[4];
		                $("#ruleContnum").attr("data",ruleconList)
		                var allList = ret.split("^")[5];
		                $("#allcatnum").attr("data",allList)*/
		         }
				 
			};
		var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryIncInfoJson&params="+params; 
		new ListComponent('druginfodg', columns, uniturl, option).Init();
}
function SetCellOperation(value, rowData, rowIndex)
{
	var drugId = rowData.drugId;
	var btn = "<img class='mytooltip' onclick=\"editProp('"+drugId+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
  	return btn;  
}
function editProp(drugId)
{
	
		var dicParref = serverCall("web.DHCCKBDrugRuleMaintain","GetEntyId",{"DrugId":drugId});
	
		var linkUrl="dhcckb.editprop.csp"
		var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?parref='+drugId+'&dicParref='+dicParref+'"></iframe>';
		if($('#win').is(":visible")){
			$("#win").remove();
		}
		if($('#winmodel').is(":visible")){return;}  //窗体处在打开状态,退出
		$('body').append('<div id="winmodel"></div>');
		$('#winmodel').window({
						title:'实体知识维护',
						collapsible:true,
						border:false,
						closed:"true",
						modal:true,
						//maximized:true,
						maximizable:true,
						minimizable:false,		
						width:$(window).width()-50, //800,
						height:$(window).height()-50,//500
		});	

		$('#winmodel').html(openUrl);
		$('#winmodel').window('open');
}
///查询
function query()
{
	var check="0";
	if($("#manurep").get(0).checked) {
		var check="1"
  	}else{
	    var check="0"
  	}
	var params = $HUI.combobox("#hosp").getValue() +"^"+ $HUI.combobox("#drugname").getText() +"^"+ $HUI.combobox("#genename").getText() +"^"+ $HUI.combobox("#ingredient").getText() +"^"+ $HUI.combobox("#emptyval").getValue()+"^"+check;
 	params = params +"^^"+ $("#drugcat").combotree("getText");
 	$('#druginfodg').datagrid('load',{
		 params:params
	}); 
}


///重置
function reset()
{
		$HUI.combobox("#hosp").setValue("") ;
		$HUI.combobox("#drugname").setValue(""); 
		$HUI.combobox("#genename").setValue("") ;
		$HUI.combobox("#ingredient").setValue("");
		$HUI.combobox("#emptyval").setValue("");
		var params = $HUI.combobox("#hosp").getValue() +"^"+ $HUI.combobox("#drugname").getText() +"^"+ $HUI.combobox("#genename").getText() +"^"+ $HUI.combobox("#ingredient").getText()+"^"+ $HUI.combobox("#emptyval").getValue();
			$('#druginfodg').datagrid('load',{
				params:params
			}); 
}
///复制分类
function repliccat(value, rowData, rowIndex)
{
		var drugId = rowData.drugId;
		var drugCatId = rowData.drugCatId;
		var type = rowData.type
		return "<a href='#' onclick=\"showEditWin('"+drugId+"','"+drugCatId+"','"+type+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";
}
function showEditWin(drugId,drugCatId,type)
{
		$("#catpanel").html("");
		var myWin = $HUI.dialog("#copywin",{
						iconCls:'icon-write-order',
						resizable:true,
						title:'分类复制',
						modal:true,
						width:800,
						height:480,
						buttonAlign : 'center',
						buttons:[{
										text:'提交',
										iconCls:'icon-save',
										id:'save_btn',
										handler:function(){				
											submit(drugId,type);
										}
						},{
										text:'关闭',
										iconCls:'icon-close',
										handler:function(){
											myWin.close();
										}
						}]
			});	
		console.log(drugCatId)
		runClassMethod("web.DHCCKBCalculateval","GetDrugCatHtml",{"drugCatId":drugCatId},function(data){
					$(data).appendTo("#catpanel");
					$('.hisui-checkbox').checkbox()
		},'text');
}
function submit(drugId,type)
{
	var catIdArr = []
 	$("input[name='cat'][type='checkbox']:checked").each(function(){
	   catIdArr.push(this.id);
	})
	var catList = catIdArr.join("^");
	runClassMethod("web.DHCCKBCalculateval","InsertCat",{"drugId":drugId,"listData":catList,"type":type},function(data){
				if(data==0){
						$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
						$HUI.dialog("#copywin").close();
						//$("#druginfodg").datagrid('reload');
				}else{
						$.messager.alert("提示","保存失败"+data)
				}
	},'text');
}
///查看疾病
function linkdiseInfo(value, rowData, rowIndex)
{
	var drugId = rowData.drugId;
	return "<a href='#' onclick=\"showdisWin('"+drugId+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";

}
function showdisWin(drugId)
{
	$("#disease").html("");
	var myWin = $HUI.dialog("#diswin",{
			iconCls:'icon-write-order',
			resizable:true,
			title:'疾病查询',
			modal:true,
			width:800,
			height:480,
			buttonAlign : 'center',
			buttons:[{
							text:'关闭',
							iconCls:'icon-close',
							handler:function(){
								myWin.close();
							}
			}]
	});	
	runClassMethod(
		"web.DHCCKBCalculateval",
		"QueryDisease",
			{
				"drugId":drugId
			},function(data){
				$("#disease").html(data);
	},'text');
}
function openDisWin(inobj)
{
	$("#disease").html("");
	var myWin = $HUI.dialog("#diswin",{
			iconCls:'icon-write-order',
			resizable:true,
			title:'疾病查询',
			modal:true,
			width:800,
			height:480,
			buttonAlign : 'center',
			buttons:[{
							text:'关闭',
							iconCls:'icon-close',
							handler:function(){
								myWin.close();
							}
			}]
	});	
	
	$("#disease").html($(inobj).attr("data"));
}

function addEqUnitOperation(value,rowData, rowIndex){
	
	var drugId = rowData.drugId;
	var equnit = rowData.equunit;
	var hisEqUnit = rowData.hisequunit; 
	var btn = "<img class='mytooltip' onclick=\"addEqUnit('"+drugId+"','"+equnit+"','"+hisEqUnit+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
  	return btn;  
  	
}
/// 增加等效单位
function addEqUnit(drugId,equnit,hisEqUnit){
		
	alert(drugId+":"+equnit+":"+hisEqUnit)
	$.messager.confirm("提示", "您确定要导入his等效单位吗？", function (res) {	// 提示是否删除
		if (res) {			
			runClassMethod("web.DHCCKBCalculateval","AddHisEqUnit",{"drugId":drugId,"hisEqUnit":hisEqUnit,"sysEqUnit":equnit,"loginInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
			
				if (jsonString == 0){
					$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
				}	
				else{
					$.messager.popover({msg: '保存失败！！',type:'error',timeout: 1000});
				}
			})
				
		}
	});		
	
	

}