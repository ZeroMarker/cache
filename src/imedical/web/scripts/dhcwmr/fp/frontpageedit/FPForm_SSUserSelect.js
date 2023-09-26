//obj.cboUser = FP_SSUserSelect("cboUser","术者","OPRDOC");
function FP_SSUserSelect(){
	var TypeCode = arguments[2];
	var pageSize = (arguments[3] ? arguments[3] : 100);
	var anchor = (arguments[4] ? arguments[4] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCWMR.FPService.SSUserSrv';
						param.QueryName = 'QryUserByAlias';
						param.Arg1 = tmpCombo.getRawValue();
						param.Arg2 = TypeCode;
						param.Arg3 = pageSize;
						param.ArgCnt = 3;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'UserID'
			}, 
			[
				{name: 'UserID', mapping: 'UserID'}
				,{name: 'UserInitials', mapping: 'UserInitials'}
				,{name: 'UserName', mapping: 'UserName'}
				,{name: 'UserPinYin', mapping: 'UserPinYin'}
				,{name: 'CTPID', mapping: 'CTPID'}
				,{name: 'CTPCode', mapping: 'CTPCode'}
				,{name: 'CTPDesc', mapping: 'CTPDesc'}
				,{name: 'CTPTpDesc', mapping: 'CTPTpDesc'}
				,{name: 'CTPIntTp', mapping: 'CTPIntTp'}
			])
		})
		,minChars : 100
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table style="border-bottom:1px #BDBDBD solid;">',
				'<thead align="center"><tr>',
					'<th align="center" width="5%">ID</th>',
					'<th align="center" width="25%">工号</th>',
					'<th align="center" width="25%">姓名</th>',
					'<th align="center" width="45%">类型</th>',
				'</tr></thead>',
				'<tbody>',
					'<tpl for=".">',
						'<tr class="x-combo-list-item">',
							'<td align="center">{[xindex]}</td>',
							'<td align="center">{UserInitials}</td>',
							'<td align="left">{UserName}</td>',
							'<td align="left">{CTPTpDesc}</td>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:240
		,valueField : 'UserID'
		,displayField : 'UserName'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : anchor
		,enableKeyEvents : true
		,listeners: {
			'keydown' : function(field, e){
				if ((e.getKey() == e.ENTER)||(e.getKey() == e.DOWN)){
					if (field.isExpanded() == false){
						//检查是否触发Tab键
						if (e.getKey() == e.ENTER){
							if (field.id == 'FPO_RowEditor_Operator'){  //术者
								if (((objScreen.FPO_RowEditor.OperatorId != '')&&(objScreen.FPO_RowEditor.OperatorTxt == field.getRawValue()))
								||((objScreen.FPO_RowEditor.OperatorId == '')&&(field.getRawValue() == '')))
								{
									event.keyCode=9;  //触发Tab键
									return;
								}
							} else if (field.id == 'FPO_RowEditor_Ass1'){  //1助
								if (((objScreen.FPO_RowEditor.Ass1Id != '')&&(objScreen.FPO_RowEditor.Ass1Txt == field.getRawValue()))
								||((objScreen.FPO_RowEditor.Ass1Id == '')&&(field.getRawValue() == '')))
								{
									event.keyCode=9;  //触发Tab键
									return;
								}
							} else if (field.id == 'FPO_RowEditor_Ass2'){  //2助
								if (((objScreen.FPO_RowEditor.Ass2Id != '')&&(objScreen.FPO_RowEditor.Ass2Txt == field.getRawValue()))
								||((objScreen.FPO_RowEditor.Ass2Id == '')&&(field.getRawValue() == '')))
								{
									event.keyCode=9;  //触发Tab键
									return;
								}
							} else if (field.id == 'FPO_RowEditor_NarDoc'){  //麻醉医师
								if (((objScreen.FPO_RowEditor.NarDocId != '')&&(objScreen.FPO_RowEditor.NarDocTxt == field.getRawValue()))
								||((objScreen.FPO_RowEditor.NarDocId == '')&&(field.getRawValue() == '')))
								{
									event.keyCode=9;  //触发Tab键
									return;
								}
							} else {
								event.keyCode=9;  //触发Tab键
								return;
							}
						}
						//加载Store数据
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success) {
								if (success){
									field.setValue('');
								}
							}
						});
					} else {
						//if (e.getKey() == e.ENTER){
						//	event.keyCode=9;  //触发Tab键
						//}
					}
				}
			}
			,'render' : function(field){
				field.getEl().on('dblclick', function(field){
					var field = tmpCombo;
					if (field.isExpanded() == false){
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success) {
								if (success){
									field.setValue('');
								}
							}
						});
					}
				});
			}
			,'blur' : function(){
				if (this.getValue() == ''){
					this.setRawValue('');
				} else if (this.getRawValue() == ''){
					this.setValue('');
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}