$(function(){
    $.extend(GenHospComp("Doc_OPAdm_CanCreatBook").jdata.options,{
        onSelect:function(index,row){
			LoadCfgData();
			$('#searchLoc').searchbox('setValue','');
			$("#tabOPLocList").datagrid('reload');
			$('#i-hospital').combobox('select',$('#_HospList').getValue());
        },
        onLoadSuccess:function(data){
			InitSearchBox();
			LoadCfgData();
            InitOPLocGrid();
			InitCreateSelCheck();
			InitCanCreateHosp();
            InitEvent();
        }
    });
});
function InitEvent(){
	$('#BSave').click(SaveCfgData);
	$('#BSaveCreateLoc').click(SaveInLocCfgData);
	$('.in-loc-list').on('click','[name]',InLocClick);
}
function InitSearchBox()
{
	var SearchTimer=null;
    $('#searchLoc').searchbox({
        prompt:'请输入科室别名...',
    }).searchbox('textbox').keyup(function(e){
		clearTimeout(SearchTimer);
		SearchTimer=setTimeout(function(){
			$('#tabOPLocList').datagrid('localFilter',{
				text:$(e.target).val(),
				columns:['text','alias']
			});
		},300);
	});
}
function InitOPLocGrid()
{
	$("#tabOPLocList").datagrid({
		idField:'id',
		bodyCls:'panel-body-gray',
		toolbar:[{
			text:'保存',
			iconCls: 'icon-save',
			handler: function(){
				var SaveRows=$('#tabOPLocList').datagrid('getEditRows');
				if(!SaveRows.length){
					$.messager.popover({msg:"没有需要保存的数据",type:'alert'});
					return;
				}
				var ret=$.cm({
					ClassName:'DHCDoc.DHCDocConfig.IPBook',
					MethodName:'SaveOPLocCfgData',
					InputStr:JSON.stringify(SaveRows),
					HospID:$('#_HospList').getValue(),
					dataType:'text'
				},false);
				if(ret=='0'){
					$.messager.popover({ msg: '保存成功!',type:'success'});
					$('#tabOPLocList').datagrid('load');
				}else{
					$.messager.alert('提示','保存失败:'+ret);
				}
			}
		}],
		queryParams:{ClassName : "DHCDoc.DHCDocConfig.IPBook",QueryName : "QueryOPLoc"},
		columns :[[
			{field:'id',hidden:true},
			{field:'text',title:'科室',width:150},
			{field:'InPatLoc', title: '可开住院科室',width: 150,align:'center',
        		formatter:function(value,rec){  
					if(!value) value='增加';
					return '<a href="#" onclick="LocSelectShow(\''+rec.id+'\')">'+value+'</a>';
	            }
        	},
			{field:'NeedtoDate',title:'需录入实际入院日期和时间',width:70,align:'center',
				editor : {
					type : 'icheckbox',
					options : {
						on : 'Y',
						off : 'N'
					}
				},
				styler: function(value,row,index){
					if (value=="Y"){
						return 'color:#21ba45;';
					}else{
						return 'color:#f16e57;';
					}
				},
				formatter:function(value,record){
					if (value=="Y") return "是";
					else  return "否";
				}
			},
			{field:'NeedtoPre',title:'需开启预住院审批',width:70,align:'center',
				editor : {
					type : 'icheckbox',
					options : {
						on : 'Y',
						off : 'N'
					}
				},
				styler: function(value,row,index){
					if (value=="Y"){
						return 'color:#21ba45;';
					}else{
						return 'color:#f16e57;';
					}
				},
				formatter:function(value,record){
					if (value=="Y") return "是";
					else  return "否";
				}
			}
		]],
		onDblClickRow:function(index, row){
            $(this).datagrid('beginEdit',index);
        },
		onBeforeLoad:function(param){
			param.HospID=$('#_HospList').getValue();
		},
		onLoadSuccess:function(){
			$(this).prev().find('.datagrid-body').find('div.datagrid-cell').overflowtip();
		}
	});
}
function LoadCfgData()
{
	$('.div-flex').parent().showMask();
	var keys=$('.div-flex').getFormKeys();
	$.cm({
		ClassName:'DHCDoc.DHCDocConfig.IPBook',
		MethodName:'GetMulDocConfig',
		NodeStr:JSON.stringify(keys), 
		HospID:$('#_HospList').getValue()
	},function(data){
		$('.div-flex').setFormData(data);
		$('.div-flex').parent().hideMask();
	});
}
function SaveCfgData()
{
	var data=$('.div-flex').getFormData();
	var ret=$.cm({
		ClassName:'DHCDoc.DHCDocConfig.IPBook',
		MethodName:'SaveMulDocConfig',
		InputStr:JSON.stringify(data), 
		HospID:$('#_HospList').getValue(),
		dataType:'text'
	},false);
	if(ret=='0'){
		$.messager.popover({msg: '保存成功!',type:'success'});
	}else{
		$.messager.alert('提示','保存失败:'+ret);
	}
}
function LocSelectShow(LocID)
{
	$('#dialog-createloc').dialog('open');
	$('#dialog-createloc').dialog('options').LocID=LocID;
	LoadCanCreateLoc();
}
function CreateLocOnClose()
{
	$('#dialog-createloc').dialog('options').LocID=null;
}
function InitCanCreateHosp()
{
	$('#i-hospital').combobox({
		editable:false,
		onBeforeLoad:function(param){
			param.ClassName='DHCDoc.DHCDocConfig.IPBook';
			param.QueryName='QueryHospital';
		},
		onLoadSuccess:function(data){
			if(data.length) $(this).combobox('select',$('#_HospList').getValue());
		},
		onSelect:function(){
			LoadCanCreateLoc();
		}
	});
}
function LoadCanCreateLoc()
{
	$('.in-loc-list').empty();
	var LocID=$('#dialog-createloc').dialog('options').LocID;
	if(!LocID) return;
	$.cm({
		ClassName:'DHCDoc.DHCDocConfig.IPBook',
		QueryName:'QueryLocInLoc',
		LocID:LocID, 
		HospID:$('#i-hospital').getValue(),
		rows:9999
	},function(data){
		$.each(data.rows,function(index,locObj){
			var $locName=$('<div>'+locObj.text+'</div>').attr('name','locname').attr('CanCreatBook',locObj.CanCreatBook);
			var $locDefault=$('<div>'+(locObj.DefCreatBookLoc?'默认':'设置为默认')+'</div>').attr('name','locdefault').attr('DefCreatBookLoc',locObj.DefCreatBookLoc);
			if(locObj.CanCreatBook) $locName.addClass('loc-selected');
			var $loc=$('<div></div>').attr('locid',locObj.id).append($locName).append($locDefault);
			$('.in-loc-list').append($loc);
		});
	});
}
function InLocClick()
{
	var name=$(this).attr('name');
	if(name=='locname'){
		var CanCreatBook=eval($(this).attr('CanCreatBook'));
		if(!DefCreatBookLoc){
			$(this).next().attr('DefCreatBookLoc',false);
		}
		$(this).attr('CanCreatBook',!CanCreatBook);
		if(CanCreatBook) $(this).next().text('设置为默认');
		//$('#create-loc-select').checkbox('setValue',$('.in-loc-list').find('div[name="locname"][CanCreatBook="false"]').size()==0);
	}else if(name=='locdefault'){
		var DefCreatBookLoc=eval($(this).attr('DefCreatBookLoc'));
		if(!DefCreatBookLoc){
			$('.in-loc-list').find('div[name="locdefault"][DefCreatBookLoc="true"]').attr('DefCreatBookLoc',false).text('设置为默认');
			$(this).prev().attr('CanCreatBook',true);
		}
		$(this).attr('DefCreatBookLoc',!DefCreatBookLoc);
		$(this).text(!DefCreatBookLoc?'默认':'设置为默认');
	}
}
function InitCreateSelCheck()
{
	$('#create-loc-select').checkbox({
		onChecked:function(){
			$('.in-loc-list').find('div[name="locname"][CanCreatBook="false"]').attr('CanCreatBook',true);
		},
		onUnchecked:function(){
			$('.in-loc-list').find('div[name="locdefault"][DefCreatBookLoc="true"]').attr('DefCreatBookLoc',false).text('设置为默认');
			$('.in-loc-list').find('div[name="locname"][CanCreatBook="true"]').attr('CanCreatBook',false);
		}
	});
}
function SaveInLocCfgData()
{
	var OPLocID=$('#dialog-createloc').dialog('options').LocID;
	var InLocArr=new Array();
	$('.in-loc-list').find('div[name="locname"][CanCreatBook="true"]').each(function(){
		var InLocID=$(this).parent().attr('locid');
		InLocArr.push(InLocID);
	});
	var DefCreatBookLocID="";
	if($('.in-loc-list').find('div[name="locdefault"][DefCreatBookLoc="true"]').size()){
		DefCreatBookLocID=$('.in-loc-list').find('div[name="locdefault"][DefCreatBookLoc="true"]').eq(0).parent().attr('locid');
	}
	var ret=$.cm({
		ClassName:'DHCDoc.DHCDocConfig.IPBook',
		MethodName:'SaveMulDocConfig2',
		InputStr:JSON.stringify({
			CanCreatBookLocStr:InLocArr.join('^'),
			DefCreatBookLocID:DefCreatBookLocID
		}),
		Node1:'IPBBook',
		Node2:OPLocID,
		HospID:$('#i-hospital').getValue(),
		dataType:'text'
	},false);
	if(ret=='0'){
		$.messager.popover({ msg: '保存成功!',type:'success'});
		$('#tabOPLocList').datagrid('load');
	}else{
		$.messager.alert('提示','保存失败:'+ret);
	}
}