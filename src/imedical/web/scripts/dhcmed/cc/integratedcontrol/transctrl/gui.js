var objScreen = null;
function InitWinControl(SubjectID)
{
	var obj = new Object();
	objScreen = obj;
	obj.SubjectID = SubjectID;
	obj.ViewConfigCode = ViewConfigCode;
	
	obj.SelectNode=null;
	obj.loadParamArg1="";
	obj.loadParamArg2="";
	obj.loadParamArg3="";
	obj.loadParamArg4="";
	obj.loadParamArg5="";
	obj.loadParamArg6="";
    obj.loadParamArg7="";
	
    obj.selLocDr = "";
    obj.selWardDr = "";
	
    obj.mnuMenu = new Ext.menu.Menu({
        items : [
               {
                   id : 'mnuSendMsg',
                   text : '<B>发送反馈<B/>',
                   icon : '../scripts/dhcmed/img/warn.png'                   
               },
                "-",
               {
                   id : 'mnuBaseInfo',
                   text : '<B>摘要<B/>',
                   iconCls : 'icon-woman'                   
               },
                "-",
	       {
                   id : 'mnuViewObservation',
                   text : '<B>生命体征<B/>',
                   iconCls : 'icon-man'
               }
        ]
    })
	
	obj.TreeControlsTreeLoader = new Ext.tree.TreeLoader({
			nodeParameter : 'Arg1',
			dataUrl : "dhcmed.cc.ctrl.ninfitemtree.csp",
			baseParams : {
				SubjectID:obj.SubjectID
                ,ViewConfigCode : obj.ViewConfigCode
			}
	});
	obj.TreeControls = new Ext.tree.TreePanel({
		buttonAlign : 'center'
		,region : 'center'
		,width:300
		,rootVisible:false
		,autoScroll:true
		,loader : null  //obj.TreeControlsTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'root',text:'root'})
	});
	obj.ConditionPanel1 = new Ext.form.FormPanel({
		id : 'ConditionPanel1'
		,layout : 'fit'
		//,region : 'center'
		,height : 350
		,items:[
			obj.TreeControls
		]
	});
	
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '开始日期'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,value : new Date().add(Date.DAY, -7)
		,value : new Date().add(Date.DAY, -1)
	});
	obj.dfDateTo = new Ext.form.DateField({
		id : 'dfDateTo'
		,width : 100
		,fieldLabel : '结束日期'
		,altFormats : 'Y-m-d|d/m/Y'
		,format : 'Y-m-d'
		,anchor : '99%'
		//,value :new Date()
		,value : new Date().add(Date.DAY, -1)
	});

	obj.radioVisitI = new Ext.form.Checkbox({
		id : 'radioVisitI'
		,name : 'radioVisit'
		,boxLabel : '在院'
		,inputValue : 'I'
	});
	obj.radioVisitO = new Ext.form.Checkbox({
		id : 'radioVisitO'
		,name : 'radioVisit'
		,boxLabel : '出院'
		,inputValue : 'O'
	});
	obj.radioVisit = new Ext.form.CheckboxGroup({
		id : 'radioVisit'
		,fieldLabel : '在院状态'
		,items:[
			obj.radioVisitI
			,obj.radioVisitO
		]
	});
	obj.chkRelation = new Ext.form.Checkbox({
		id : 'chkRelation'
		,name : 'chkRelation'
		,boxLabel : '并列条件'
		,fieldLabel : '运算逻辑'
		,inputValue : '1'
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '查询'
		,width : 70
	});
    obj.btnExport = new Ext.Button({
		id:'btnExport'
		,iconCls:'icon-export'
		,text:'导出'
		,width : 70
    });
	obj.ConditionPanel2 = new Ext.form.FormPanel({
		id : 'ConditionPanel2'
		,buttonAlign : 'center'
		,layout : 'form'
		//,frame:true
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		//,region : 'south'
		,height : 160
		,items:[
			obj.dfDateFrom
			,obj.dfDateTo
			,obj.radioVisit
			,obj.chkRelation
		]
		,buttons:[
			obj.btnQuery
			//,obj.btnExport
		]
	});
	obj.ConditionPanel = new Ext.Panel({
		id: 'ConditionPanel'
		,region : 'west'
		,title: '查询条件'
		//,collapsible : true
		,split:true
		,width:250
		,border:true
		,layoutConfig: {animate: true}
		,layout: 'form'
		,frame : true
		,items:[
			obj.ConditionPanel1
			,obj.ConditionPanel2
		]
	});
	
	obj.objTpl = new Ext.XTemplate(
		'<div>',
		'<div class="SubTotal">', 
			'<table width="100%">',
				'<tr>',
					 '<td width="160" class="SubTotal_td"><img src="../scripts/dhcmed/img/cc/08.png" width="98" height="31" /></td>',
					 '<td width="30%" class="SubTotal_td">查找到的病例数量：</td>',
					 '<td width="50%" class="SubTotal_td"><span class="SubTotal_Number">{total}个</span></td>',
				'</tr>',
			'</table>',
		'</div>',
		'<tpl for="record">',
			'<DIV id="frame-{Paadm}" CLASS="t-bg">',
				'<div class="t-header">',
					 '<div class="t-header-left">',
						'<div class="t-header-text">{FireCatFlag}&nbsp;&nbsp;{PatName}&nbsp;&nbsp;{PapmiNo}&nbsp;&nbsp;{Sex}&nbsp;&nbsp;{Age}&nbsp;&nbsp;{AdmitDate}&nbsp;&nbsp;{AdmWard}&nbsp;&nbsp;{AdmDoc}&nbsp;&nbsp;',
							'{[this.getReportList(values)]}',
							'<div class="ButtonGroup">',
								//'<a href="#" onclick="return objScreen.viewPatientInfo({Paadm},{LastSummaryID})"><img src="../scripts/dhcmed/img/cc/summary.png" alt="摘要"></a>',
								//'<a href="#" onclick="return objScreen.btnNoticeDoctor_onclick({LastSummaryID},\'{LnkSummaryIDs}\')"><img src="../scripts/dhcmed/img/cc/notice.png" alt="提示医师" /></a>',
							'</div>',
						'</div>',
					 '</div>',
				'</div>',
				'<div class="mas">',
					'<div>',
						'<div id="divCtlResult-{Paadm}"><img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',
						'<div id="divInf-{Paadm}"><img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',
						'{[this.FormatHTML(values)]}',
					'</div>', 
				'</div>',
			'</Div>',
		'</tpl>',
		'</div>',
		{
			getReportList : function(values)
			{
				var ret = '';
				if (RepType == 'ICU'){
					ret = '<a href="#" onclick="return objScreen.btnNewICUReport_onclick(' + values.Paadm + ',\'' + values.RepLocID + '\')">ICU调查登记表</a>'
				} else if (RepType == 'NICU'){
					ret = '<a href="#" onclick="return objScreen.btnNewNICUReport_onclick(' + values.Paadm + ',\'' + values.RepLocID + '\')">新生儿调查登记表</a>'
				} else if (RepType == 'OPR'){
					ret = '<a href="#" onclick="return objScreen.btnNewOPRReport_onclick(' + values.Paadm + ',\'' + values.RepLocID + '\')">手术切口调查表</a>'
				} else {
					//
				}
				return ret;
			},
			getChildString : function(node)
			{
				var str = "";
				/*
				var childnodes = node.childNodes;
				for(var i=0;i<childnodes.length;i++){
					var childnode = childnodes[i];
					var nodeList = childnode.id.split("-");
					if (nodeList.length>2){
						if (nodeList[1]=="I"){
							//if (childnode.attributes.checked){
								str = str + nodeList[0] + "/";
							//}
						}
					}
					str += getChildString(childnode);
				}*/
				str = obj.allCtrlSubCats;
				return str;
			},
			FormatHTML : function(values){
				var EpisodeID = values.Paadm;
				
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.CCService.Feedback.ResultService',
						QueryName : 'qryCtlResultByEpisodeID',
						Arg1 : EpisodeID,
						Arg2 : SubjectID,
						Arg3 : "", //IsSensitive
						Arg4 : "", //IsSpecificity
						Arg5 : 0, //Min Score
						Arg6 : '', //Subject Item ID
						Arg7 : this.getChildString(objScreen.TreeControls.getRootNode()),
						Arg8 : '', //obj.dfDateFrom.getRawValue(),
						Arg9 : '', //obj.dfDateTo.getRawValue(),
						ArgCnt : 9
					},
					success: function(response, opts) {
						var objData = Ext.decode(response.responseText);
						var arryData = new Array();
						var objItem = null;
						for(var i = 0; i < objData.total; i ++)
						{
							objItem = objData.record[i];
							arryData[arryData.length] = objItem;
						}
						objINTCCommon.RenderCtlResult("divCtlResult-" + EpisodeID, arryData);
					},
					failure: function(response, opts) {
						//document.getElementById("divCtlResult-" + SummaryID).innerHTML = response.responseText;
						var objTargetElement = document.getElementById("divCtlResult-" + EpisodeID);
						if (objTargetElement) {
							objTargetElement.innerHTML = response.responseText;
						}
					}
				});
				
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.CCService.Feedback.EpisodeService',
						QueryName : 'QryInfReportByEpisodeID',
						Arg1 : EpisodeID,
						ArgCnt : 1
					},
					success: function(response, opts) {
						var objData = Ext.decode(response.responseText);
						var arryData = new Array();
						var objItem = null;
						for(var i = 0; i < objData.total; i ++)
						{
							objItem = objData.record[i];
							arryData[arryData.length] = objItem;
						}
						objINTCCommon.RenderInfReport("divInf-" + EpisodeID, arryData);
					},
					failure: function(response, opts) {
						//document.getElementById("divInf-" + SummaryID).innerHTML = response.responseText;
						var objTargetElement = document.getElementById("divInf-" + EpisodeID);
						if (objTargetElement) {
							objTargetElement.innerHTML = response.responseText;
						}
					}
				});
			}
		}
	);
	
	obj.objLocBedTpl = new Ext.XTemplate(
		'<div>',
		'<div class="SubTotal">', 
			'<table width="100%">',
				'<tr>',
					 '<td width="160" class="SubTotal_td"><img src="../scripts/dhcmed/img/cc/08.png" width="98" height="31" /></td>',
					 '<td width="30%" class="SubTotal_td">查找到的病例数量：</td>',
					 '<td width="50%" class="SubTotal_td"><span class="SubTotal_Number">{total}个</span></td>',
				'</tr>',
			'</table>',
		'</div>',
		'<table  width="100%" border="0" style="padding-left:10px"><tbody>',
			'{[this.StartFormatHTML()]}',
			'<tpl for="record">',
				'{[this.FormatHTML(values,5)]}',
			'</tpl>',
			'{[this.EndFormatHTML(5)]}',
		'</tbody></table>',
		'</div>',
		{
			StartFormatHTML : function()
			{
				obj.PatNum = 0;
				return '';
			},
			EndFormatHTML : function(colCount)
			{
				var ret = '';
				var PatNum = obj.PatNum;
				if ((PatNum-1)%colCount != (colCount-1)) {
					var xcolnum = (colCount-1)-((PatNum-1)%colCount)
					for (var xcol=0;xcol<xcolnum;xcol++) {
						ret += '<td width="20%" ><table class="locbedctrl-tb" id="tb-Null' + xcol + '" width="100%"><tbody><tr><td></td><tr></tbody></table></td>'
					}
					ret += '</tr>'
				}
				return ret;
			},
			FormatHTML : function(values,colCount)
			{
				var PatNum = obj.PatNum;
				PatNum++;
				obj.PatNum = PatNum;
				
				var ret = '';
				if ((PatNum-1)%colCount == 0) ret += '<tr>';
				
				ret += '<td width="20%" valign="top" >'
				ret += '<div class="locbedctrl01">'
				ret += '<a href="#" onclick="objScreen.DisplayControlPatientDetail(\''+values.RepLocID + '\',\'' +values.RepLocDesc +'\',\'\',\''+values.Paadm + '\');" >'
				ret += '<table class="locbedctrl-tb" id="tb-' + values.Paadm + '" width="100%">'  //class="wardctrl-tb"
				ret +=     '<tr>'
				ret +=         '<td  align="center" colspan="2" style="font-size:14px" >' + values.PatName + '(' + values.Sex + ')' + '<br></td>'
				ret +=     '</tr>'
				//ret +=     '<tr>'
				//ret +=         '<td  align="center" colspan="2" style="font-size:20px" ><b>' + values.AdmBed + '</b><br></td>'
				//ret +=     '</tr>'
				
				ret +=     '<tr><td  align="right" colspan="2">'
				var arryData = values.SubCatList.split(String.fromCharCode(1));
				var arryFields = null;
				for(var i = 0; i < arryData.length; i ++)
				{
					if(arryData[i] == '') continue;
					if ((i+1)%colCount==1) {
						ret += '<br>'
					}
					arryFields = arryData[i].split('^');
					ret +=     '<span title="'+arryFields[1]+'">'
					ret +=         '<img height="16px" width="16px" src="../scripts/dhcmed/img/cc/' + ViewConfigCode +  '/' + arryFields[3] + '.png" />' + arryFields[2] 
					ret +=     '</span>&nbsp;&nbsp;'
				}
				ret +=     '</td></tr>'
				
				ret += '</table>'
				ret += '</a>'
				ret += '</div>'
				ret += '</td>'
				
				if ((PatNum-1)%colCount == (colCount-1)) ret += '</tr>';
				return ret;
			}
		}
	);
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.dataViewStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.dataViewStore = new Ext.data.Store({
		/*sortInfo: {
			field: 'Number',
			direction: 'DESC' // or 'DESC' (case sensitive for local sorting)
		},*/
		proxy: obj.dataViewStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'WardID'
		}, 
		[
			{name: 'WardID', mapping : 'WardID'}
			,{name: 'WardDesc', mapping: 'WardDesc'}
			,{name: 'PatientNum', mapping: 'PatientNum'}
			,{name: 'SubCatList', mapping: 'SubCatList'}
			,{name: 'FiredPatNum', mapping : 'FiredPatNum'}
		])
	});
	 obj.dataviewQryResult = new Ext.DataView({
		obj : 'center',
        store: obj.dataViewStore,
		overClass:'x-view-over',
		style:'background-color:#ecf1f5',
        itemSelector:'div.thumb-wrap',
        tpl  : new Ext.XTemplate(
			'<table  width="100%" border="0" style="padding-left:10px"><tbody>',
				'{[this.StartFormatHTML()]}',
				'<tpl for=".">',
					'{[this.FormatHTML(values,4)]}',
				'</tpl>',
				'{[this.EndFormatHTML(4)]}',
			'</tbody></table>',
			{
				StartFormatHTML : function()
				{
					obj.WardNum = 0;
					return '';
				},
				EndFormatHTML : function(colCount)
				{
					var ret = '';
					var WardNum = obj.WardNum;
					if ((WardNum-1)%colCount != (colCount-1)) {
						var xcolnum = (colCount-1)-((WardNum-1)%colCount)
						for (var xcol=0;xcol<xcolnum;xcol++) {
							ret += '<td width="20%" ><table class="wardctrl-tb" id="tb-Null' + xcol + '" width="100%"><tbody><tr><td></td><tr></tbody></table></td>'
						}
						ret += '</tr>'
					}
					return ret;
				},
				FormatHTML : function(values,colCount)
				{
					var WardNum = obj.WardNum;
					WardNum++;
					obj.WardNum = WardNum;
					
					var ret = '';
					if ((WardNum-1)%colCount == 0) ret += '<tr>';
					
					ret += '<td width="20%" valign="top" >'
					ret += '<div class="wardctrl01">'
					ret += '<table class="wardctrl-tb" id="tb-' + values.WardID + '" width="100%">'  //class="wardctrl-tb"
					ret +=     '<tr>'
					ret +=         '<td  align="center" colspan="2" style="font-size:14px" >' + values.WardDesc + '<br><br></td>'
					ret +=     '</tr>'
					ret +=     '<tr>'
					ret +=         '<td align="right" width="50%" style="padding-right:0px">当前在院：</td>'
					ret +=         '<td align="left" width="50%">' + values.PatientNum + '</td>'
					ret +=     '</tr>'
					ret +=     '<tr>'
					
					ret +=         '<td align="right" width="50%" style="padding-right:0px">触发人数：</td>'
					ret +=         '<td align="left" width="50%"><a href="#" onclick="objScreen.DisplayControlPatientDetail(\''+values.WardID + '\',\'' +values.WardDesc +'\',\'\',\'\');" >' + values.FiredPatNum + '</a></td>'
					
					ret +=     '</tr>'
					ret +=     '<tr><td  align="right" colspan="2">'
					var arryData = values.SubCatList.split(String.fromCharCode(1));
					var arryFields = null;
					for(var i = 0; i < arryData.length; i ++)
					{
						if(arryData[i] == '') continue;
						if ((i+1)%colCount==1) {
							ret += '<br><br>'
						}
						arryFields = arryData[i].split('^');
						ret +=     '<span title="'+arryFields[1]+'">'
						ret +=         '<a href="#" onclick="objScreen.DisplayControlPatientDetail(\'' + values.WardID + '\',\'' + values.WardDesc + '-' + arryFields[1] + '\',\'' + arryFields[0] + '\',\'\')">'
						ret +=             '<img height="16px" width="16px" src="../scripts/dhcmed/img/cc/' + ViewConfigCode +  '/' + arryFields[3] + '.png" />' + arryFields[2] 
						ret +=     '</a></span>&nbsp;&nbsp;'
					}
					ret +=     '</td></tr>'
					ret += '</table>'
					ret += '</div>'
					ret += '</td>'
					
					if ((WardNum-1)%colCount == (colCount-1)) ret += '</tr>';
					return ret;
				}
			}
        ),
        id: 'images-view',
        singleSelect: true,
        autoScroll  : true
    });	
	
	obj.pnSummary = new Ext.Panel({
		autoScroll : true
		,title : '摘要'
		,layout : 'fit'
		,items : [ obj.dataviewQryResult]
	});
	
	obj.DataGridPanel = new Ext.Panel({
		region : 'center'
		,autoScroll : true
		//,style : 'overflow-x:hidden; overflow-y:scroll'
		,tpl : obj.objTpl
		,title : '明细'
	});
	
	obj.DataLocBedPanel = new Ext.Panel({
		region : 'center'
		,autoScroll : true
		//,style : 'overflow-x:hidden; overflow-y:scroll'
		,tpl : obj.objLocBedTpl
		,title : '床位图'
	});
	
	obj.tabResult = new Ext.TabPanel({
		activeTab: 0
		,region : 'center'
		,items : [
			obj.pnSummary,
			obj.DataLocBedPanel,
			obj.DataGridPanel
		]
	});
	
	obj.WinControl = new Ext.Viewport({
		id: 'WinControl'
		,layout : 'border'
		,items: [
			obj.ConditionPanel
			,obj.tabResult
		]
	});
	
	InitWinControlEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}