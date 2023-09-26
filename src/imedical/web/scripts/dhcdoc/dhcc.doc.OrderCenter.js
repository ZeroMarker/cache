/**!
* @author: wanghc
* @date:   2012-04-06
*/
Ext.namespace('dhcc.doc');
/**
* @param {Ext.GridPanel} MixGridPanel
* @return {Object} һ��Ĭ�ϵĴ����������
* ���� grid1 �� �Ҽ�����һ����¼.
	var operateHandlerObject = dhcc.doc.getOperateProxy(grid1);
	var menu = new Ext.menu.Menu({items:[
		{
			text: '����',
			act: 'CancelAct',	//��̨��������
			handler: operateHandlerObject.defaultHandler
		}
	]});
	grid1.rightKeyMenu = menu;
	��ᷢ�� {rid:rowid,act:act} ��Ϊ����������,�����ڳɹ�ʱˢ��ҳ��,ʧ��ʱ��ʾ.
*/
dhcc.doc.getOperateProxy = function ( grid ){		
	var url = 'dhcdoc.request.csp';
	var succ = function(resp,opts){
		var rtn = resp.responseText.replace(/\r\n/g,"");
		try{var obj = Ext.decode(rtn);}catch(e){alert("����ʧ��!");return ;}
		if (obj.msg == "0"){					
			/*
			�ص�
			*/
			if (obj.Method && obj.Method !="undefined" && obj.OrdList && obj.OrdList !="undefined" && obj.OrdList!=""){
				if (("^StopPrnOrder^CancelPrnOrder^UnUsePrnOrder^").indexOf("^"+obj.Method+"^")>=0){
					ExeCASigin(obj.OrdList)
				}
			}
			var startIndex = grid.getBottomToolbar().cursor;
			grid.store.load({params:{start: startIndex}});
			if(grid.deselectHd) grid.deselectHd();
			if(grid.orderSelectArr) grid.orderSelectArr.length = 0; //���������ѡ��
			if(grid.orderSelectObjs) grid.orderSelectObjs.length = 0; //���������ѡ��
			if(grid.ExecOrderSelectArr) grid.ExecOrderSelectArr.length = 0; //���������ѡ��
			if(grid.ExecOrderSelectObjs) grid.ExecOrderSelectObjs.length = 0; //���������ѡ��
			if (window.parent.name=="dataframe184"){
				window.parent.location.reload()
			}
			
			if(obj.succmsg){
				Ext.Msg.alert("<font size=5>��ʾ</font>","<font size=4>" + obj.succmsg+"</font>");
			}
		}else{
			Ext.Msg.alert("<font size=5>��ʾ</font>","<font size=4>����: " + obj.msg+"</font>");
		}	
	};
	var fail =  function(resp,opts){ 
		Ext.Msg.alert("��ʾ","����ʧ��!");
	};
	var sendAjax = function(b, e, exParams,callbackFun){
		//if(!b.act){ alert("û������ act ����"); return ;}
		var obj, ids = "",r;
		if(grid["getSelectedRowIds"]){
			ids = grid.getSelectedRowIds();
		}else{ 
			r = grid.getSelectionModel().getSelected();
			if(r){ ids = r.data["HIDDEN1"]; }	//Ĭ�ϵ�һ����id��
		}	
		if(!ids) {alert("û��ѡ�м�¼!");return;}
		if(callbackFun){
			obj = Ext.apply({params: {rid: ids}}, {url: url, success: callbackFun, failure: fail});
		}else{
			obj = Ext.apply({params: {rid: ids}}, {url: url, success: succ, failure: fail});				
		}
		if(exParams){
			Ext.apply(obj.params, exParams);
		}
		Ext.Ajax.request(obj);
	};
	return {
		url: url,
		succ : succ,
		fail : fail,
		/**
		* @param {Object} b  --�簴ť �˵���..
		* @param {EventObject} e 
		* @param {Object} exParams	��Ӳ���,Ĭ�ϼ��� {params:{id: 'rowid' ,act: 'act',},url:'reqcsp', success: succ, failure: fail}
		* �����̨ 
		*/
		sendAjax : sendAjax,
		defaultHandler: function(b, e){
			Ext.Msg.confirm('��ʾ', 'ȷ�� ' + b.text+ ' ��?', function(btn, text){;	
				if(btn == 'yes'){ sendAjax(b,e);} 
			})
		}
		
	}
}
var dateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
if (dateFormat=="3"){
    dateFormat="Y-m-d"
}else if(dateFormat=="4"){
	dateFormat="d/m/Y"
}else{
	dateFormat="Y-m-d";
}
Ext.ux.DateField=Ext.extend(Ext.form.DateField,{
	//anchor : '100%',
//	width : 80,
	format: dateFormat,
	invalidClass:'',
	invalidText:'',
	regexText:'��������ȷ�����ڸ�ʽ!',
	initComponent:function(){
		var altFormats = 'j|d|md|ymd|Ymd'+'|Y-m|Y-n|y-m|y-n'+'|Y-m-d|Y-m-j|Y-n-d|Y-n-j|y-m-d|y-m-j|y-n-d|y-n-j';
		var regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|((\d{4}|\d{2})\-\d{1,2}\-\d{1,2}))$/;
		if(dateFormat == 'm/d/Y'){
			altFormats = 'j|d|md|mdy|mdY'+'|n/j|n/d|m/j|m/d'+'|n/j/y|n/j/Y|n/d/y|n/d/Y|m/j/y|m/j/Y|m/d/y|m/d/Y';
			regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{1,2}\/\d{1,2}\/(\d{4}|\d{2})))$/;
		}else if(dateFormat == 'd/m/Y'){
			altFormats = 'j|d|dm|dmy|dmY'+'|j/n|j/m|d/n|d/m'+'|j/n/y|j/n/Y|j/m/y|j/m/Y|d/n/y|d/n/Y|d/m/y|d/m/Y';
			regex = /^(t|(t[\+\-]\d*)|\d{1,2}|\d{4}|\d{6}|\d{8}|(\d{1,2}\/\d{1,2}\/(\d{4}|\d{2})))$/;
		}
		this.altFormats = altFormats;
		this.regex = regex;
		this.on('blur',function(e){
			var str=this.getRawValue();
			str=str.replace(/\s/g,"").toLowerCase();
			if(str=="t"){
				this.setValue(new Date());
			}
			else if(str.indexOf("t+")==0 || str.indexOf("t-")==0){
				var addDayNum=parseInt(str.substring(2));
				if(isNaN(addDayNum)){
					this.setValue('');
				}else{
					if(addDayNum=="") {addDayNum=0;}
					if(str.substring(1,2)=="-"){
						addDayNum=-addDayNum;
					}
					this.setValue(new Date().add(Date.DAY, parseInt(addDayNum)));
				}
			}else{
				this.setValue(this.getValue());
			}
		});
		this.on('specialkey',function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				this.fireEvent('blur');
			}
		});
		Ext.ux.DateField.superclass.initComponent.call(this);
	},
	/*
	 * ��дDateField��parseDate����,����6λ���ָ�ʽ���������⴦��
	 */
	parseDate : function(value) {
		if(!value || Ext.isDate(value)){
			return value;
		}
		var v = this.safeParse(value, this.format),
			af = this.altFormats,
			afa = this.altFormatsArray;
		if (!v && af) {
			afa = afa || af.split("|");
			for (var i = 0, len = afa.length; i < len && !v; i++) {
				if(afa[i] == 'ymd' && Ext.isString(value) && (Number(value) == value) && value.length == 6 && value.substring(2,4) > 12){
					//��if��Ϊ���⴦����, ����201609(��3,4Ϊ>12)ȡ�������һ��,��20160930
					var firstDay = Date.parseDate(value + '01', 'Ymd');
					v = firstDay.getLastDateOfMonth();
				}else{
					v = this.safeParse(value, afa[i]);
				}
			}
		}
		return v;
	}
});
Ext.reg('uxdatefield',Ext.ux.DateField);

/**
* @class dhcc.doc.OrderCenter
* @extends dhcc.icare.MixGridPanel
* @desc:   ҽ����ѯ��
*/
dhcc.doc.OrderCenter = Ext.extend(dhcc.icare.MixGridPanel, {
	title: "",
	split:true,
	region:'center',
	/**
	* @cfg {String} orderId ҽ��RowId����
	*/
	orderId : 'HIDDEN1',
	/**
	* @cfg {String} orderDesc ҽ����������
	*/
	orderDesc : 'TOrderDesc',	
	/**
	* @cfg {String} orderDesc ҽ��״̬��������
	*/
	orderStatuCode : 'HIDDEN2',
	/**
	* @cfg {String} dateFormat 
	* ҳ������ڸ�ʽ
	*/		
	dateFormat: dateFormat,
	
	/**
	* @cfg {String} dateFormat 
	* ҳ���ʱ���ʽH:i 24Сʱ��ʽ  19:18
	*/	
	timeFormat: 'H:i',	
	/**
	* @cfg {String} requestCSP
	* ���ֲ�����Ӧ�ĺ�̨ҳ��
	*/
	requestCSP : "dhcdoc.request.csp",
	//loadAct : "FindPrnOrder",					
	/**
	* @cfg {String} loadDoctorAct
	* ��ҽ����combobox��̨action
	*/
	loadDoctorAct : "doctorList",
	/**
	* @cfg {int} pageSize
	* ҽ��ҳ��һҳ��ʾ������
	*/
	pageSize : 15,
	/*
	*��¼����ҳ��ѡ�м�¼id
	*{Array} orderSelectArr
	*/	
	orderSelectArr : [],
	/*
	*��¼����ҳ��ѡ�м�¼Index
	*{Array} orderSelectArr
	*/
	orderSelectObjs: [],
	/**
	* @private ֹͣ����ʱͣ��ͣ����
	*/
	isStopGroupOrder : tkMakeServerCall("web.DHCDocConfig","GetConfigNode","StopGroupOrder"),
	/**
	* Rewrite
	*/
	cmHandler : function(cms){
		//var that = this;
		var len = cms.length, i, statuCode = this.orderStatuCode,  orderDesc = this.orderDesc;
		for( i = 0 ; i < len; i++){		
			if(cms[i].dataIndex == orderDesc){
				cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){					
					if( ['D','C'].indexOf(record.get(statuCode)) > -1 ){
						if (record.get(statuCode)=="D"){
							//return value+"  <font color=red>ֹͣ</font>";
							//value=value+"  <font color=red>ֹͣ</font>";
						}else{
							//return value+"  <font color=red>����</font>";
							//value=value+"  <font color=red>����</font>";
						}
						//return value+"  <font color=red>DC-"+record.get(statuCode)+"</font>"
					}
					var inparaOrderDesc = Ext.getCmp("orderDesc").getValue();
					if (inparaOrderDesc!=""){
						value = value.replace(inparaOrderDesc,"<font color=red>"+inparaOrderDesc+"</font>");
						//return value;
					}
					//return value;
					metaData.attr = 'ext:qtip="' + "<font size=3>"+value+"</font>" + '"'; 
                    return value;
				} 
			}else if(cms[i].dataIndex=="TStopDate"){
				cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){
					if( value!="" ){
						var now = new Date().getTime();
						if (value.indexOf("-")!="-1") var stopdate = Date.parseDate(value,'Y-m-d').getTime();
						if (value.indexOf("/")!="-1") var stopdate = Date.parseDate(value,'d/m/Y').getTime();	
						if(stopdate > now){
							//that.getView().getCell(rowIndex,colIndex+1).style = 'background-color: yellow;';
							//that.getView().getCell(rowIndex,colIndex+2).style = 'background-color: yellow;';
							metaData.attr = "style='background-color: yellow;'";							
						}
					}
					return value;
				}
			}else if(cms[i].dataIndex=="TStopTime"){
				cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){
					if( record.data['TStopDate']!="" ){
						var now = new Date().getTime();
						if (value.indexOf("-")!="-1") var stopdate = Date.parseDate(record.data['TStopDate'],'Y-m-d').getTime();
						if (value.indexOf("/")!="-1") var stopdate = Date.parseDate(record.data['TStopDate'],'d/m/Y').getTime();				
						//var stopdate = Date.parseDate(record.data['TStopDate'],'Y-m-d').getTime(); 
						if(stopdate > now){
							metaData.attr = "style='background-color: yellow;'";
						}
					}
					return value;
				}
			}else if(cms[i].dataIndex=="TStopDoctor"){
				cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){
					if( record.data['TStopDate']!="" ){
						var now = new Date().getTime();		
						if (value.indexOf("-")!="-1") var stopdate = Date.parseDate(record.data['TStopDate'],'Y-m-d').getTime();
						if (value.indexOf("/")!="-1") var stopdate = Date.parseDate(record.data['TStopDate'],'d/m/Y').getTime();						
						//var stopdate = Date.parseDate(record.data['TStopDate'],'Y-m-d').getTime(); 
						if(stopdate > now){
							//that.getView().getCell(rowIndex,colIndex-1).style = 'background-color: yellow;';
							//that.getView().getCell(rowIndex,colIndex-2).style = 'background-color: yellow;';
							metaData.attr = "style='background-color: yellow;'";
						}
					}
					return value;
				}
			}else if(cms[i].dataIndex=="CustomSelected"){	//���Բ��ú�̨ ��д
				cms[i].width = 37;
				cms[i].fixed = true;
				cms[i].header = "<input type='checkbox' id='checkboxhd' />";
				cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){								
					var arr = value.split("-"),vl;
					var len = store.getCount();
					if(arr.length>1 && arr[1]>0){
						//ѡ��ҽ��ʱ,��ҽ��Ҳѡ�� onclick='"+vl+"'
						//vl = "javascript:for(var i=1;i<="+arr[1]+";i++){if((+i+"+rowIndex+")<"+len+"){ document.getElementById(\"checkbox\"+(+i+"+(rowIndex)+")).checked=this.checked;}}"
						return "<input type='checkbox' id='checkbox"+rowIndex+"' oeorigroup='" + value + "'  />";			
					}
					return "<input type='checkbox' id='checkbox"+rowIndex+"' oeorigroup='" + value + "' />";				
					 //<div class="x-grid3-row-checker">&#160;</div>';
				}		
			}
		}
		return cms;
	},
	selectAll: function(){
		var that = this;		
		this.store.each(function(r,i){
			if (r.data[that.orderId]!="") {
				that.orderSelectArr.remove(r.data[that.orderId]);		//���ѡ��
				document.getElementById("checkbox"+i).checked = true;
				that.orderSelectArr.push(r.data[that.orderId]);
				
				that.orderSelectObjs.remove(r.data);		//���ѡ��
				that.orderSelectObjs.push(r.data);
			}
			
		});
	},
	deselectHd:	function(){
		document.getElementById("checkboxhd").checked = false;
	},
	deselectAll: function(){
		var that = this;
		this.store.each(function(r,i){
			that.orderSelectArr.remove(r.data[that.orderId]);
			document.getElementById("checkbox"+i).checked = false;
			
			that.orderSelectObjs.remove(r.data);
			
		});
	},
	onHdMouseDown : function(e,t){
		e.stopEvent();
		var flag = document.getElementById("checkboxhd").checked;
		if(flag===true){
			this.deselectAll();
		}else{
			this.selectAll();
		}
	},
	/**
	*׷��ѡ����
	*/
	checkboxSelects : function (rowIndex) {		
		document.getElementById("checkbox"+rowIndex).checked = true;
	},
	/**
	*ֻѡ�и���
	*/
	checkboxSelect : function(rowIndex){
		this.store.each(function(r,i){
			document.getElementById("checkbox"+i).checked = false;		
		});
		this.checkboxSelects(rowIndex);
	},
	/**
	* @method getSelectedRow	���ѡ�е���
	* @return {Record} record
	*/
	getSelectedRow : function(){
		var obj,rowrecord;		
		this.store.each(function(r,i){
			obj = document.getElementById("checkbox"+i);
			if(obj && obj.checked){
				rowrecord = r;
			}					
		})
		return rowrecord ;
	},
	/**
	* @method getSelectedRowId	���ѡ�е��е�hidden1�ֶε�ֵ
	* @return {String} ids    id1^id2^id3
	*/
	getSelectedRowIds : function(){
		var obj, ids = "", orderId = this.orderId;		
		this.store.each(function(r,i){
			obj = document.getElementById("checkbox"+i);
			if(obj && obj.checked){
				if("" == ids){ 
					ids = r.data[orderId];
				}else{ 
					ids += "^" + r.data[orderId];
				}
			}					
		})
		return ids ;
	},
	getAllPageSelectedRowIds: function(){
		return this.orderSelectArr.join("^");
	},
	/*��ȡ����ѡ����Index*/
	getAllPageSelectedRowObjs: function(){
		return this.orderSelectObjs //.join("^");
	},
	/**
	* Rewrite
	*/
	initEvents: function(){
		dhcc.doc.OrderCenter.superclass.initEvents.call(this);
		this.on("rowcontextmenu", function(g,rowIndex,e){
			g.store.each(function(r,i){				
				g.getView().onRowDeselect(i);									
			});
			g.checkboxSelect(rowIndex);					//�Ҽ����Ϲ�,����ʲôʱ��ȥ�˹���
			//g.getSelectionModel().selectRow(rowIndex);
			g.getView().onRowSelect(rowIndex);		
		});
		this.on("rowdblclick",function(g,num,e){							
			g.store.each(function(r,i){				
				g.getView().onRowDeselect(i);									
			});
			g.checkboxSelect(num);		 	//�Ҽ����Ϲ�,����ʲôʱ��ȥ�˹���			
			//g.getSelectionModel().selectRow(rowIndex); 
			g.getView().onRowSelect(num);											
		});
		this.getSelectionModel().on("rowselect",function(t, rowIndex, record){			
			var selectr = record;
			var g = t.grid;
			var selectoeori = selectr.data["HIDDEN3"];
			if (selectoeori == ""){ selectoeori = selectr.data[g.orderId]; }
			g.store.each(function(r,i){				
				g.getView().onRowDeselect(i);
				if ( (r.data["HIDDEN3"] == selectoeori) || (r.data[g.orderId] == selectoeori) ){				
					g.getView().onRowSelect(i);
				}				
			});
		});
		Ext.fly("checkboxhd").on("mousedown",this.onHdMouseDown,this);
		var that = this;
		
		this.store.on("load",function(s,rs){
			var storeCount = s.getCount();
			s.each(function(r,i){
				var cbobj = document.getElementById("checkbox"+i);
				var cbgroupLen = cbobj.getAttribute("oeorigroup").split("-")[1];
				if(cbgroupLen>0){ //master order - color
					that.getView().getRow(i).style.backgroundColor="#60f807" ;//'#00ccff';
				}
				//var lastRowNo = parseInt(cbgroupLen)+parseInt(i);
				//�Զ�ѡ����ǰ���������ڸ���ҽ��
				if(that.orderSelectArr.indexOf(r.data[that.orderId])>-1){
					cbobj.checked = true;
				}
				if (r.data["ColorFlag"]==1){
					that.getView().getRow(i).children[0].style.color="#808080"
				}
				Ext.EventManager.addListener(cbobj,"click",function(evt,t,obj){
					var checkboxObj ;
					var oeorditemId = r.data[that.orderId];
					var oeorioeoridr = r.data["HIDDEN3"];
					if (r.data[that.orderId]!=""){
						for (var j=0;j<storeCount;j++){
							checkboxObj = document.getElementById("checkbox"+j);						
							//ѡ������
							if(s.getAt(j).data["HIDDEN3"]==oeorditemId) {
								checkboxObj.checked=t.checked;							
							}
							//ѡ�и������ֵ�
							if (that.isStopGroupOrder==1){
								if((oeorioeoridr!="" && s.getAt(j).data[that.orderId]==oeorioeoridr)||((oeorioeoridr!="") && (s.getAt(j).data["HIDDEN3"]==oeorioeoridr))){
									checkboxObj.checked=t.checked;
								}
							}
							that.orderSelectArr.remove(s.getAt(j).data[that.orderId]);
							that.orderSelectObjs.remove(s.getAt(j).data);
							
							if(checkboxObj.checked==true){
								that.orderSelectArr.push(s.getAt(j).data[that.orderId]);
								that.orderSelectObjs.push(s.getAt(j).data);
							}
						}	
					}				
				});
				
			});
		});		
		/* this.on('rightKeyMenuShow',function(g, rowIndex){
			var r = g.store.getAt(rowIndex);
			if(r.data["TDeptRowid"]){
				if(session['LOGON.CTLOCID'] != r.data["TDeptRowid"]) return false;
			}
			return true;
		}) */
		/* this.on("afterrender",function(ths){
			var frm = dhcsys_getmenuform();
			var adm = frm.EpisodeID.value;
			if (frm && frm.EpisodeID.value !== "0" ) {
				ths.store.removeAll();
				Ext.apply(ths.store.baseParams, {P1: frm.PatientID.value, P2: adm, P3: 0, P4 : 1, P5 : 1});				
				ths.store.load();
				this.conditionCmp[0].store.baseParams.adm = adm;		
			}		
		}); */
	},
	getPatientJson : function () {
		//�����ѯ�������������
		var p = this.store.baseParams;
		if (p.P1){
			return {"PatientID":p.P1,"EpisodeID":p.P2,"mradm":p.P2};
		}
		var frm = dhcsys_getmenuform();
		if (frm && frm.EpisodeID){
			return {"PatientID":frm.PatientID.value,"EpisodeID":frm.EpisodeID.value,"mradm":frm.EpisodeID.value};
		}
		return "";
	},
	//ֻ�ǵ�һ��ˢҳ��ʱ��,�˵��Բ���ʾ����,���ؿ�ҽ����
	refreshData: function ( pc ) {
		document.getElementById("checkboxhd").checked = false;
		this.orderSelectArr = [];
		this.orderSelectObjs = [];
		var flag = false;
		if (this.rendered){
			var adm ,papmi;
			if (pc.adm){
				adm = pc.adm;
				papmi = pc.papmi;
			}else{
				var frm = dhcsys_getmenuform();
				if (frm && frm.EpisodeID){
					adm = frm.EpisodeID.value;
					papmi = frm.PatientID.value;
				}
			}
			if((adm != "") && (adm != this.store.baseParams.P2)) flag = true;
			if(pc && (pc["forceRefresh"]== true)) flag = true;
			if ( flag ) {
				this.store.removeAll();	
				var obj = { P1: papmi,  P2: adm};
				var ccs = this.conditionCmp; 
				var len = ccs.length;
				for (var i = 0; i < len ; i++){
					ccs[i].setValue(ccs[i].originalValue);				//ѡ��Ĭ��
					obj["P"+ccs[i].paramPosition] = ccs[i].getValue();	//��Ĭ��ֵд��������
				}
				Ext.apply(this.store.baseParams, obj);
				//var totalParams = Ext.apply( {GetTotal:1}, this.store.baseParams );	
				//��ֹ��ѡ����ҽ���Ļ��ߣ���ѡ����ҽ���Ļ��ߣ�ͳ�ƻ���ҽ����������
				var totalParams = Ext.apply( {GetTotal:0}, this.store.baseParams );				
				var that = this;
				Ext.Ajax.request({
					url: this.dataUrl,
					params: totalParams,
					callback: function(request,succ,response){
						if (dhcc.doc.execOrder){
							dhcc.doc.execOrder.refreshData({P1: '', P2: '', P3: ''});
						}
						if (dhcc.doc.feeOrder){
							dhcc.doc.feeOrder.refreshData({P1: ''});
						}
						var total = +(response.responseText);
						var remain = total%that.pageSize;
						var start = 0;
						if (total==0) return ;
						if (remain==0){
							start = total - that.pageSize;
						}else{
							start = total - remain;
						}
						//that.store.baseParams.start = total - remain ;
						that.store.load({ params:{start: start}});	
					}
				});
				

				this.conditionCmp[1].store.baseParams.adm = adm;
				this.conditionCmp[1].store.load();				
			};			
		}		
	},	
	tbar: [
		'ҽ��',{
			paramPosition: 7, 
			xtype:"field",
			width: 110,
			name: "orderDesc",
			id: "orderDesc",		
			value:''
		},
		'��ҽ����',			
		{	
			xtype: 'combo',
			paramPosition: 3, 
			typeAhead: true,
			fieldLabel: '��ҽ����',
			width: 65,
			name: "doctorList",
			id: "doctorList",
			triggerAction: 'all',
			//allQuery:,
			lazyRender: true,		
			mode:'remote',
			store: new Ext.data.ArrayStore({
				fields: ['userRowid','userDesc'],
				baseParams: {act: 'doctorList'},
				url: "dhcdoc.request.csp"			
			}),
			displayField: 'userDesc',
			valueField:'userRowid',
			allowBlank: false,
			editable:false,
			value: 'ȫ��'
		},
		'-','��Χ',
		{ 
			paramPosition: 4, 
			xtype:"combo",	
			typeAhead: true,
			fieldLabel: '��Χ',
			width: 80,
			name: "scopeDesc",
			id: "scopeDesc",
			triggerAction: 'all',
			lazyRender: true,		
			mode:'local',
			value:3,
			store: new Ext.data.ArrayStore({
				fields: ['scopeId','scopeDesc'],
				data:[[1,"ȫ��"],[2,"����"],[3,"��ǰ"],[4,"�����"],[5,"��ֹͣ"]]
			}),
			displayField: 'scopeDesc',
			valueField:'scopeId',
			editable:false,
			allowBlank:  false
		},
		'-','��������',
		{ 	
			paramPosition: 5, xtype:"combo", typeAhead: true,
			fieldLabel: '��������',
			width: 110,
			editable:false,
			name: "locDesc",
			id: "locDesc",
			triggerAction: 'all',
			lazyRender: true,		
			mode:'local',
			value:1,
			store: new Ext.data.ArrayStore({
				fields: ['locId','locDesc'],
				data:[[1,"�������벡��"],[2,"��������"],[3,"ȫ��"]]
			}),
			displayField: 'locDesc',
			valueField:'locId',
			allowBlank:  false
		}
	]
})



function ExeCASigin(OrdList)
{
	var ContainerName="";
	var caIsPass=0;
	debugger
	if (CAInit==1) 
	{  
		//�жϵ�ǰkey�Ƿ��ǵ�½ʱ���key
        var rtn=dhcsys_getcacert();
        //alert("dhcsys_getcacert out: rtn:"+rtn)
        //alert("dhcsys_getcacert out: rtn.IsSucc:"+rtn.IsSucc)
        //alert("dhcsys_getcacert out: rtn.ContainerName:"+rtn.ContainerName)
        if (rtn.IsSucc){
			if (rtn.ContainerName==""){
				ContainerName="";
        		caIsPass=0;
			}else{
				ContainerName=rtn.ContainerName;
        		caIsPass=1;
			}
		}else {
			ContainerName="";
        	caIsPass=0;
			alert("ǩ��ʧ��");
            return false;
		}
 
        var ret=SaveCASign(ContainerName,OrdList,"S");
	}
}


function SaveCASign(ContainerName,OrdList,OperationType) 
{    try{
	//alert(ContainerName+","+OrdList+","+OperationType)
      if (ContainerName=="") return false;
      //1.������֤
	    var CASignOrdStr="";
	    var TempIDs=OrdList.split("^");
		var IDsLen=TempIDs.length;
		for (var k=0;k<IDsLen;k++) {
			var TempNewOrdDR=TempIDs[k].split("&");
			if (TempNewOrdDR.length <=0) continue;
			var newOrdIdDR=TempNewOrdDR[0];
			if (newOrdIdDR.indexOf("!")>0){
				newOrdIdDR=newOrdIdDR.split("!")[0];
			}
			
			if(CASignOrdStr=="")CASignOrdStr=newOrdIdDR;
			else CASignOrdStr=CASignOrdStr+"^"+newOrdIdDR;			
		}
		var SignOrdHashStr="",SignedOrdStr="",CASignOrdValStr="";
		var CASignOrdArr=CASignOrdStr.split("^");
		for (var count=0;count<CASignOrdArr.length;count++) {
			var CASignOrdId=CASignOrdArr[count];
			var OEORIItemXML=cspRunServerMethod(GetOEORIItemXMLMethod,CASignOrdId,OperationType);
			var OEORIItemXMLArr=OEORIItemXML.split(String.fromCharCode(2));
			for (var ordcount=0;ordcount<OEORIItemXMLArr.length;ordcount++) {
				if (OEORIItemXMLArr[ordcount]=="")continue;
  				var OEORIItemXML=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[1];
   				var OEORIOperationType=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[0];
				//$.messager.alert("����","OEORIItemXML:"+OEORIItemXML);
				var OEORIItemXMLHash=HashData(OEORIItemXML);
				//$.messager.alert("����","HashOEORIItemXML:"+OEORIItemXMLHash);
				if(SignOrdHashStr=="") SignOrdHashStr=OEORIItemXMLHash;
				else SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&"+OEORIItemXMLHash;
				//$.messager.alert("����",ContainerName);
				var SignedData=SignedOrdData(OEORIItemXMLHash,ContainerName);
				if(SignedOrdStr=="") SignedOrdStr=SignedData;
				else SignedOrdStr=SignedOrdStr+"&&&&&&&&&&"+SignedData;
				if(CASignOrdValStr=="") CASignOrdValStr=OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
				else CASignOrdValStr=CASignOrdValStr+"^"+OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
			}
		}
		if (SignOrdHashStr!="")SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&";
		if (SignedOrdStr!="")SignedOrdStr=SignedOrdStr+"&&&&&&&&&&";
		//��ȡ�ͻ���֤��
    	var varCert = GetSignCert(ContainerName);
    	var varCertCode=GetUniqueID(varCert);
		/*
		alert("CASignOrdStr:"+CASignOrdStr);
		alert("SignOrdHashStr:"+SignOrdHashStr);
		alert("varCert:"+varCert);
		alert("SignedData:"+SignedOrdStr);
		*/
    	if ((CASignOrdValStr!="")&&(SignOrdHashStr!="")&&(varCert!="")&&(SignedOrdStr!="")){
			//3.����ǩ����Ϣ��¼																												CASignOrdValStr,session['LOGON.USERID'],"A",					SignOrdHashStr,varCertCode,SignedOrdStr,""
			var ret=cspRunServerMethod(InsertCASignInfoMethod,CASignOrdValStr,session['LOGON.USERID'],OperationType,SignOrdHashStr,varCertCode,SignedOrdStr,"");
			if (ret!="0") {
				alert("����ǩ��û�ɹ�");
				return false;
			}else{
				alert("CA sucess")
			}
		}else{
	  		alert("����ǩ������");
	  		return false;
		} 
		return true;
	}catch(e){alert("CA err:"+e.message);return false;}
}