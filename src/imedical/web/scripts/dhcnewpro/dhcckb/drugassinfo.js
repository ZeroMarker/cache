var editRow=0;
var editcomRow=0;
var editdosRow=0;
$(function(){ 

	initCombobox();
	initButton();
	initDrugInfoList();

})

///��ʼ��combobox
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
						{value:'Gene',text:'ͨ����Ϊ��'},
						{value:'Comp',text:'�ɷ�Ϊ��'},
						{value:'Dosa',text:'����Ϊ��'},
						{value:'Cat',text:'����Ϊ��'},
						{value:'Drug',text:'ҩƷΪ��'},
						{value:'Rule',text:'����Ϊ��'},
						{value:'FormGen',text:'������ͨ����Ϊ��'},
						{value:'Manuf',text:'����Ϊ��'},
						{value:'Equunit',text:'��Ч��λΪ��'},
						{value:'Noninunit',text:'��Ч��λ�в����������е�λ'},
						{value:'Verrule',text:'��˲����'},
						{value:'UsaDos',text:'�÷������д��ڵ���ý��Һ'},
						{value:'Indicat',text:'��Ӧ֢Ϊ��'},
						{value:'Usage',text:'�÷�����Ϊ��'},
						{value:'PhaTox',text:'ҩ����Ϊ��'},
						{value:'PhaKin',text:'ҩ������ѧΪ��'},
						{value:'CancelRel',text:'����δ����'}
						
				],
				onSelect:function(ret){
						query();
			 }
	 	})
		 	
	 	///����
	 	$HUI.combotree("#drugcat",{
			url:$URL+'?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref=106',
			editable:true,
			onSelect:function(node){			
				query();
			}
		})
	 	
}

///��ʼ����ť
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

///ҩƷ�б�
function initDrugInfoList()
{
		var columns=[[
			{field:'ck',title:'����',width:60,formatter:SetCellOperation},
			{field:'drugId',title:'drugId',hidden:false},
	        {field:'drug',title:'ҩƷ����',width:320},
	        {field:'hisCode',title:'HISҩƷ����',width:120},
	        {field:'extDesc',title:'HISҩƷ����',width:220},
	        {field:'rule',title:'�Ƿ���ڹ���',width:120},
	        {field:'generFormName',title:'������ͨ����',width:120},
	        {field:'generName',title:'ͨ����',width:120},
	        {field:'drugComp',title:'�ɷ�',width:120},
	        {field:'drugDosa',title:'����',width:100},
	        {field:'drugManuf',title:'��������',width:100},
	        {field:'equunit',title:'��Ч��λ',width:100},
	        {field:'hisequunit',title:'HIS��Ч��λ',width:100},
	        {field:'addEqUnitBtn',title:'�����Ч��λ',width:100,formatter:addEqUnitOperation,align:"center"},
	        {field:'errruleNum',title:'��˲����',width:100},
	        {field:'nounitinlib',title:'��Ч��λδά���ĵ�λ',width:150},
	        {field:'drugCat',title:'ҩѧ����',width:300},
	        {field:'copyCat',title:'���Ʒ���',width:60,formatter:repliccat},
	        {field:'sameGenDrug',title:'��ͬͨ������ҩƷ����',width:450},
	        {field:'usadosRule',title:'�÷������д�����ý��Һ',width:250},
	        {field:'diseList',title:'����',width:60,hidden:false,formatter:linkdiseInfo},
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
		///  ����datagrid  
		var option = {
					nowrap:false,
					rownumbers : true,
					singleSelect : true,
				    onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
				    
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
		if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
		$('body').append('<div id="winmodel"></div>');
		$('#winmodel').window({
						title:'ʵ��֪ʶά��',
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
///��ѯ
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


///����
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
///���Ʒ���
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
						title:'���ิ��',
						modal:true,
						width:800,
						height:480,
						buttonAlign : 'center',
						buttons:[{
										text:'�ύ',
										iconCls:'icon-save',
										id:'save_btn',
										handler:function(){				
											submit(drugId,type);
										}
						},{
										text:'�ر�',
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
						$.messager.popover({msg: '����ɹ�����',type:'success',timeout: 1000});
						$HUI.dialog("#copywin").close();
						//$("#druginfodg").datagrid('reload');
				}else{
						$.messager.alert("��ʾ","����ʧ��"+data)
				}
	},'text');
}
///�鿴����
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
			title:'������ѯ',
			modal:true,
			width:800,
			height:480,
			buttonAlign : 'center',
			buttons:[{
							text:'�ر�',
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
			title:'������ѯ',
			modal:true,
			width:800,
			height:480,
			buttonAlign : 'center',
			buttons:[{
							text:'�ر�',
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
/// ���ӵ�Ч��λ
function addEqUnit(drugId,equnit,hisEqUnit){
		
	alert(drugId+":"+equnit+":"+hisEqUnit)
	$.messager.confirm("��ʾ", "��ȷ��Ҫ����his��Ч��λ��", function (res) {	// ��ʾ�Ƿ�ɾ��
		if (res) {			
			runClassMethod("web.DHCCKBCalculateval","AddHisEqUnit",{"drugId":drugId,"hisEqUnit":hisEqUnit,"sysEqUnit":equnit,"loginInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
			
				if (jsonString == 0){
					$.messager.popover({msg: '����ɹ�����',type:'success',timeout: 1000});
				}	
				else{
					$.messager.popover({msg: '����ʧ�ܣ���',type:'error',timeout: 1000});
				}
			})
				
		}
	});		
	
	

}