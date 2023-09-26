//页面Event
function InitDicEditWinEvent(obj){
	//编辑窗体
	$('#winDicEdit').dialog({
		title: '产品字典维护',
		closed: true,
		modal: true,
		isTopZindex:false,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winDicEdit').close();
			}
		}]
	});
	
    obj.LoadEvent = function(args){
		/* for(var xindex=0;xindex<tabsLength;xindex++){
			$('#btnAdd'+xindex).on('click', function(){
				obj.layer();
			});
			$('#btnEdit'+xindex).on('click', function(){
				var rd=obj.gridDictionary.getSelected();
				obj.layer(rd);
			});
			$('#btnDelete'+xindex).on('click', function(){
				obj.btnDelete_click();
			});
		} */
    }
	obj.gridDicType_onSelect = function(rd,index) {
			obj.gridDictionary.load({
						ClassName:"DHCMA.CPW.SDS.DictionarySrv",
						QueryName:"QryDictByType",
						aTypeCode:rd.BTCode	
					});
		
		}
	obj.gridDicType_edit= function(rd) {
		obj.TypeID=	rd.BTID
		Common_SetValue('Entity',rd.EntityDesc);
		Common_SetValue('DicTCode',rd.BTCode);
		Common_SetValue('DicTDesc',rd.BTDesc);
		Common_SetValue('ActiveT',rd.BTIsActive=="1"?1:0);
		var left=$("#btnAddT").offset().left+10;
		$HUI.dialog('#winDicType').open().window("move",{left:left});	
	}
	obj.gridDicType_add= function(e) {	
		obj.TypeID=	'';
		Common_SetValue('Entity',obj.QCEntityDesc);
		Common_SetValue('DicTCode','');
		Common_SetValue('DicTDesc','');
		Common_SetValue('ActiveT',0);
		var left=$("#btnAddT").offset().left+10;
		$HUI.dialog('#winDicType').open().window("move",{left:left});
	}
	obj.gridDictionary_add= function(TypeID,TypeDesc) {
		obj.DicID="";
		var rd=$('#gridDicType').datagrid('getSelected');
		if (rd) {
			Common_SetValue('DicType',rd.BTDesc);
			Common_SetValue('DicDCode','');
			Common_SetValue('DicDDesc','');
			Common_SetValue('Resume','');
			Common_SetValue('Group','');
			Common_SetValue('ActiveD',0);
			Common_SetValue('DefaultD',0);
			var left=$("#btnAddD").offset().left-5;
			$HUI.dialog('#winDictionary').open().window("move",{left:left});
		}
	}
	obj.gridDictionary_edit= function(rd) {
		obj.DicID=rd.BTID;
		Common_SetValue('DicType',rd.BTTypeDr);
		Common_SetValue('DicDCode',rd.BTCode);
		Common_SetValue('DicDDesc',rd.BTDesc);
		Common_SetValue('Resume',rd.Resume);
		Common_SetValue('Group',rd.Group);
		Common_SetValue('ActiveD',rd.BTIsActive=="1"?1:0);
		Common_SetValue('DefaultD',rd.IsDefault=="1"?1:0);
		var left=$("#btnAddD").offset().left-5;
		$HUI.dialog('#winDictionary').open().window("move",{left:left});	
	}
	$("#btnAddT").on('click',function(){
			obj.gridDicType_add();
		})
	$("#btnAddD").on('click',function(){
			obj.gridDictionary_add();
		})
	$("#btnEditT").on('click',function(){
			var rd=$('#gridDicType').datagrid('getSelected');
			obj.gridDicType_edit(rd);
		})
	$("#btnEditD").on('click',function(){
			var rd=$('#gridDictionary').datagrid('getSelected');
			obj.gridDictionary_edit(rd);
		})
	$("#SaveT").on('click',function(){
		var DicTStr=obj.TypeID+"^"+Common_GetValue('DicTCode')+"^"+Common_GetValue('DicTDesc')+"^"+obj.QCEntityID+"^"+(Common_GetValue('ActiveT')?1:0)
		var TRet=$m({
					ClassName :"DHCMA.CPW.SD.DicType",
					MethodName:"Update",
					aInputStr :DicTStr
					},false)
		if (parseInt(TRet)>0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winDicType').close()
			obj.gridDicType.reload();
		}else{
			$.messager.alert("错误提示", "更新数据错误!Error=" + TRet, 'info');
			}
	})
	$("#SaveD").on('click',function(){
		var rd=$('#gridDicType').datagrid('getSelected');
		var DicTID=rd.BTID
		var DicDStr=obj.DicID+"^"+Common_GetValue('DicDCode')+"^"+Common_GetValue('DicDDesc')+"^"+DicTID+"^^"+((Common_GetValue('ActiveD')?1:0)+"^^^^"+(Common_GetValue('DefaultD')?1:0)+"^"+Common_GetValue('Resume')+"^"+Common_GetValue('Group'))
		var DRet=$m({
					ClassName :"DHCMA.CPW.SD.Dictionary",
					MethodName:"Update",
					aInputStr :DicDStr
			},false)
		if (parseInt(DRet)>0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winDictionary').close();
			obj.gridDictionary.reload();
		}else{
			$.messager.alert("错误提示", "更新数据错误!Error=" + DRet, 'info');
			}
	})	
	$('#dicTKey').searchbox({
	    searcher:function(value,name){
	    	obj.gridDicType.load({
					ClassName:"DHCMA.CPW.SDS.DicTypeSrv",
					QueryName:"QryDicType",
					aEntityID:obj.QCEntityID,
					aKey:value		
					});
	    },
	    prompt:'请输入类型关键字/代码'
	});	
	$('#dicDKey').searchbox({
	    searcher:function(value,name){
	    	obj.gridDictionary.load({
						ClassName:"DHCMA.CPW.SDS.DictionarySrv",
						QueryName:"QryDictByType",
						aTypeCode:obj.TypeCode	,
						aKey:value
					});
	    },
	    prompt:'请输入字典关键字/代码'
	});	
}