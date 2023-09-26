function InitFPExtraItem(obj){
    obj.FPE_InitView = function(){
		obj.FPE_Editor = new Object();
		obj.FPE_Editor.Items = new Array();
		obj.FPE_DSQuery = new Array();
		obj.FPE_FPQuery = new Array();
		
		obj.FPE_LoadDSQuery();	//加载首页附加信息
		obj.FPE_LoadFPQuery();	//加载编目附加信息
		if (obj.FrontPage.FrontPageID == ''){
			for (var row = 0; row < obj.FPE_DSQuery.length; row++){
				var record = obj.FPE_DSQuery[row];
				var newIndex = obj.FPE_FPQuery.length;
				obj.FPE_FPQuery[newIndex]=record;
			}
		}
		obj.FPE_DSTemplate.overwrite("divExtraItem-DS",obj.FPE_DSQuery);	//显示首页附加信息
		obj.FPE_FPTemplate.overwrite("divExtraItem-FP",obj.FPE_FPQuery);	//显示编目附加信息
		obj.FPE_CreatEditorItems(obj.FPE_FPQuery);  //创建附加项目编辑单元
	}
	
	obj.FPE_LoadDSQuery = function(){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FPService.FPExtraItemSrv'
		url += '&QueryName=' + 'QryWFEItemToFP'
		url += '&Arg1=' + ''
		url += '&Arg2=' + obj.FrontPage.VolumeID
		url += '&Arg3=' + obj.FrontPage.FPItemID
		url += '&ArgCnt=' + 3
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var arryData = new Array();
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				arryData[arryData.length] = objItem;
			}
			
			obj.FPE_DSQuery.length = 0;
			obj.FPE_DSQuery = arryData;
			return true;
		} else {
			ExtTool.alert("提示","加载附加信息错误!");
			return false;
		}
	}
	
	obj.FPE_LoadFPQuery = function(){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FPService.FPExtraItemSrv'
		url += '&QueryName=' + 'QryWFEItemToFP'
		url += '&Arg1=' + obj.FrontPage.FrontPageID
		url += '&Arg2=' + ''
		url += '&Arg3=' + obj.FrontPage.FPItemID
		url += '&ArgCnt=' + 3
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var arryData = new Array();
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				arryData[arryData.length] = objItem;
			}
			
			obj.FPE_FPQuery.length = 0;
			obj.FPE_FPQuery = arryData;
			return true;
		} else {
			ExtTool.alert("提示","加载附加信息错误!");
			return false;
		}
	}
	
	obj.FPE_InitData = function(){
		var arrItem = obj.FPE_FPQuery;
		var cmpName = 'FPE_Editor_Item';
		var itemId = '',itemDesc = '',itemValue = '',itemText = '';
		for (var ind = 0; ind < arrItem.length; ind++){
			var objItem = arrItem[ind];
			itemId = cmpName + objItem.EItemID;
			itemDesc = objItem.EItemDesc;
			itemValue = objItem.FPEItemValue;
			itemText = objItem.FPEItemText;
			if (objItem.EItemTpCode == 'D'){
				Common_SetValue(itemId,itemValue,itemText);
			} else if (objItem.EItemTpCode == 'T'){
				Common_SetValue(itemId,itemValue);
			} else if (objItem.EItemTpCode == 'N'){
				Common_SetValue(itemId,itemValue);
			} else if (objItem.EItemTpCode == 'DD'){
				Common_SetValue(itemId,itemValue);
			} else {
				continue;
			}
		}
	}
	
	obj.FPE_DSTemplate = new Ext.XTemplate(
		'<table id="tableExtraItem_DS" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#00AEAE;text-align:center;width:100%;">',
			'<tbody>',
				'<tpl for=".">',
					'<tpl if="xindex % 3 === 1">',
						'<tr style="font-size:13px;">',
					'</tpl>',
					'<td width="10%" {[this.labelStyle()]}>{EItemDesc}：</td>',
					'<td width="20%" {[this.textStyle()]}>{FPEItemText}&nbsp;</td>',
					'<tpl if="xindex % 3 === 0">',
						'</tr>',
					'</tpl>',
				'</tpl>',
				'<tpl if="values.length % 3 !== 0">',
						'<td width="10%" {[this.labelStyle()]}>&nbsp;</td>',
						'<td width="20%" {[this.labelStyle()]}>&nbsp;</td>',
					'</tr>',
				'</tpl>',
			'</tbody>',
		'</table>',
		{
			labelStyle : function(){
				var tabEv = ''
				tabEv += ' style="border:1px solid #DAE0EF;"'
				tabEv += ' align="right"'
				return tabEv;
			},
			textStyle : function(){
				var tabEv = ''
				tabEv += ' style="border:1px solid #DAE0EF;background-color:#FFFFFF;"'
				tabEv += ' align="left"'
				return tabEv;
			}
		}
	);
	
	obj.FPE_FPTemplate = new Ext.XTemplate(
		'<table id="tableExtraItem_FP" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;width:100%;">',
			'<tbody>',
				'<tpl for=".">',
					'<tpl if="xindex % 3 === 1">',
						'<tr style="font-size:13px;">',
					'</tpl>',
					'<td width="10%" {[this.labelStyle(values.FPEIIsNeed)]}>{EItemDesc}：</td>',
					'<td width="20%" {[this.textStyle()]}><div {[this.divStyle(values)]}></div></td>',
					'<tpl if="xindex % 3 === 0">',
						'</tr>',
					'</tpl>',
				'</tpl>',
				'<tpl if="values.length % 3 !== 0">',
						'<td width="10%" {[this.labelStyle()]}>&nbsp;</td>',
						'<td width="20%" {[this.labelStyle()]}>&nbsp;</td>',
					'</tr>',
				'</tpl>',
				'<tr><td colspan="6" style="width=100%;height:5px;"></td></tr>',
			'</tbody>',
		'</table>',
		{
			labelStyle : function(IsNeed){
				var tabEv = ''
				if (IsNeed == '1'){
					tabEv += ' style="border:1px solid #DAE0EF;font-weight:bold;"'
				} else {
					tabEv += ' style="border:1px solid #DAE0EF;"'
				}
				tabEv += ' align="right"'
				return tabEv;
			},
			textStyle : function(){
				var tabEv = ''
				tabEv += ' style="border:1px solid #DAE0EF;background-color:#FFFFFF;"'
				tabEv += ' align="left"'
				return tabEv;
			},
			divStyle : function(values){
				var tabEv = ''
				tabEv += ' id="Cmp_' + 'FPE_Editor_Item' + values.EItemID + '"'
				tabEv += ' style="width:100%;overflow:hidden;"'
				return tabEv;
			}
		}
	);
	
	obj.FPE_CreatEditorItems = function(arrItem){
		obj.FPE_Editor.Items.length = 0;
		var cmpName = 'FPE_Editor_Item';
		var itemId = '',itemDesc = '',itemValue = '',itemText = '';
		for (var ind = 0; ind < arrItem.length; ind++){
			var objItem = arrItem[ind];
			itemId = cmpName + objItem.EItemID;
			itemDesc = objItem.EItemDesc;
			itemValue = objItem.FPEItemValue;
			itemText = objItem.FPEItemText;
			if (objItem.EItemTpCode == 'D'){
				var objCmp = FP_ComboDic(itemId,itemDesc,objItem.EItemDicCode);
			} else if (objItem.EItemTpCode == 'T'){
				var objCmp = FP_TextField(itemId,itemDesc);
			} else if (objItem.EItemTpCode == 'N'){
				var objCmp = FP_NumberField(itemId,itemDesc);
			} else if (objItem.EItemTpCode == 'DD'){
				var objCmp = FP_DateField(itemId,itemDesc);
			} else {
				continue;
			}
			obj.FPE_Editor.Items.push(objCmp);
		}
	}
	
	//获取编目附加信息
	obj.FPE_GetInput = function(tmpFlag){
		var strResult = '';
		var arrResult = obj.FPE_FPQuery;
		var cmpName = 'FPE_Editor_Item';
		var itemId = '',itemDesc = '',itemValue = '', itemText = '';
		for (var ind = 0; ind < arrResult.length; ind++){
			var objItem = arrResult[ind];
			itemId = cmpName + objItem.EItemID;
			itemDesc = objItem.EItemDesc;
			itemValue = '', itemText = '';
			if (objItem.EItemTpCode == 'D'){
				itemValue = Common_GetValue(itemId);
				itemText = Common_GetText(itemId);
			} else if (objItem.EItemTpCode == 'T'){
				itemValue = Common_GetValue(itemId);
			} else if (objItem.EItemTpCode == 'N'){
				itemValue = Common_GetValue(itemId);
			} else if (objItem.EItemTpCode == 'DD'){
				itemValue = Common_GetValue(itemId);
			}
			
			if (strResult != '') strResult += CHR_1
			strResult += obj.FrontPage.FrontPageID
			strResult += CHR_2 + arrResult[ind].EItemID
			strResult += CHR_2 + itemValue
			strResult += CHR_2 + itemText
		}
		return strResult;
	}
	
	//校验编目输入内容
	obj.FPE_CheckInput = function(){
		var errInfo = '';
		var arrResult = obj.FPE_FPQuery;
		var cmpName = 'FPE_Editor_Item';
		var itemId = '',itemDesc = '',itemValue = '', itemText = '';
		for (var ind = 0; ind < arrResult.length; ind++){
			var objItem = arrResult[ind];
			itemId = cmpName + objItem.EItemID;
			itemDesc = objItem.EItemDesc;
			itemValue = '', itemText = '';
			if (objItem.EItemTpCode == 'D'){
				itemValue = Common_GetValue(itemId);
				itemText = Common_GetText(itemId);
			} else if (objItem.EItemTpCode == 'T'){
				itemValue = Common_GetValue(itemId);
			} else if (objItem.EItemTpCode == 'N'){
				itemValue = Common_GetValue(itemId);
			} else if (objItem.EItemTpCode == 'DD'){
				itemValue = Common_GetValue(itemId);
			}
			if ((objItem.FPEIIsNeed > 0)&&(itemValue == '')){
				if (objItem.EItemTpCode == 'D'){
					errInfo += itemDesc + '必须选择字典中内容!<br>'
				}
				else{
					errInfo += itemDesc + '不允许为空!<br>'
				}
			}
		}
		return errInfo;
	}
}