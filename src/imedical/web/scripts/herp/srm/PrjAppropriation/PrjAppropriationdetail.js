
var Url1 = 'herp.srm.PrjAppropriationdetailexe.csp';
//alert(Url1);
var usercode = session['LOGON.USERCODE'];


var RewardApplyButton  = new Ext.Toolbar.Button({
		text: '�ύ',  
        iconCls: 'pencil',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=DetailGrid.getSelectionModel().getSelections();
		//alert(rowObj);
		var rowObj1=itemGrid.getSelectionModel().getSelections();
		var state = rowObj1[0].get("rowid");
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var j= 0; j < len; j++){
			if(rowObj[j].get("midcheckFlag")=="���ύ"){
				Ext.Msg.show({title:'ע��',msg:'���ύ�������ݲ������ύ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			//var firstAuthor=rowObj[j].get("FristAuthorName")+"��";
		 
		}
		
		function handler(id){
			
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:Url1+'?action=submit&rowid2='+rowObj[i].get("RowID")+'&userdr='+encodeURIComponent(usercode),
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'�ύ�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								DetailGrid.load({params:{start:0, limit:12,rowid:state}});								
							}else{
								var message='�ύʧ��!';
								if(jsonData.info=='���ȱ�����ύ') message="���ȱ�����ύ";
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ������ѡ��¼��?',handler);
    }
});


//////˫���ͷ����(��Դ������http://blog.csdn.net/enginetanmary/article/details/4329996)
MyGridView = Ext.extend(Ext.grid.GridView, {
            renderHeaders : function() {
                var cm = this.cm, ts = this.templates;
                var ct = ts.hcell, ct2 = ts.mhcell;
                var cb = [], sb = [], p = {}, mcb = [];
                for (var i = 0, len = cm.getColumnCount(); i < len; i++) {
                    p.id = cm.getColumnId(i);
                    p.value = cm.getColumnHeader(i) || "";
                    p.style = this.getColumnStyle(i, true);
                    if (cm.config[i].align == 'right') {
                        p.istyle = 'padding-right:16px';
                    }
                    cb[cb.length] = ct.apply(p);
                    if (cm.config[i].mtext)
                        mcb[mcb.length] = ct2.apply({
                                    value : cm.config[i].mtext,
                                    mcols : cm.config[i].mcol,
                                    mwidth : cm.config[i].mwidth
                                });
                }
                var s = ts.header.apply({
                            cells : cb.join(""),
                            tstyle : 'width:' + this.getTotalWidth() + ';',
                            mergecells : mcb.join("")
                        });
                return s;
            }
        });
viewConfig = {
    templates : {
        header : new Ext.Template(
                ' <table border="0" cellspacing="0" cellpadding="0" style="{tstyle} border-width:thin thin thin 10px;">',
                ' <thead> <tr class="x-grid3-hd-row">{mergecells} </tr>'
                        + ' <tr class="x-grid3-hd-row">{cells} </tr> </thead>',
                " </table>"),
        mhcell : new Ext.Template(
                ' <td class="x-grid3-header" colspan="{mcols}" style="width:{mwidth}px;"> <div align="center">{value}</div>',
                " </td>")
    }
};

var FundSourcesStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '�����ѧ��ҵ��֧��'], ['2', '�в�������ר���ʽ𲦿�'], ['3', '��λ�Գ�'], ['4', '���ҡ�ʡר���'], ['5', '���д���'], ['6', '����']]
		});
var FundSourcesField = new Ext.form.ComboBox({
			fieldLabel : '��Ŀ������Դ',
			width : 100,
			listWidth : 120,
			selectOnFocus : true,
			store : FundSourcesStore,
			anchor : '90%',
			//valueNotFoundText : '',  //���һ��grid�е�Ԫ�����ɵ�Ԫ�������ÿգ�
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

var FundFormStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '֧Ʊ'], ['2', '�ֽ�'], ['3', '����']]
		});
var FundFormField = new Ext.form.ComboBox({
			fieldLabel : '������ʽ',
			width : 100,
			listWidth : 120,
			selectOnFocus : true,
			store : FundFormStore,
			anchor : '90%',
			//valueNotFoundText : '',  //���һ��grid�е�Ԫ�����ɵ�Ԫ�������ÿգ�
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
		
		
/*
var ArriveDateFields = new Ext.form.DateField({
		id : 'ArriveDateFields',
		format : 'Y-m-d',
		fieldLabel:'¼��ʱ��',
		width : 120,
		editable:true,
		allowBlank: false,
		emptyText : '��ѡ��ʼ����...'
	
		
		});
*/
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.srm.PrjAppropriationdetailexe.csp?action=applyerList',
						method : 'POST'
					});
		});

var user1Combo = new Ext.form.ComboBox({
			fieldLabel : '������ ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});



 function Todate(num) { 
 
            num = num + "";
            var date = "";
            var month = new Array();
            month["Jan"] = 1; month["Feb"] = 2; month["Mar"] = 3; month["Apr"] = 4; month["May"] = 5; month["Jan"] = 6;
            month["Jul"] = 7; month["Aug"] = 8; month["Sep"] = 9; month["Oct"] = 10; month["Nov"] = 11; month["Dec"] = 12;
            var week = new Array();
            week["Mon"] = "һ"; week["Tue"] = "��"; week["Wed"] = "��"; week["Thu"] = "��"; week["Fri"] = "��"; week["Sat"] = "��"; week["Sun"] = "��";
            str = num.split(" ");
            date = str[5] + "-";
            date = date + month[str[1]] + "-" + str[2];
            return date;
        };
/**
  renderer: function(value,metaData,record,colIndex,store,view) {
            value = Ext.util.Format.date(value,'Y-m-d H:i:s');
               return (value==null||value=="")?"--":value;
        }
**/

	var arriveexpenditure = new Ext.form.TextField({
		id: 'arriveexpenditure',
		fieldLabel: '��λ����',
		width:200,
		//allowBlank: false,
		listWidth : 260,
		//regex:/[0-9]/,
		//regexText:"��ȱ���ֻ��Ϊ����",
		triggerAction: 'all',
		//emptyText:'��ȱ���ֻ��Ϊ����',
		regex: /^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/,
		regexText : "ֻ��������",
		name: 'arriveexpenditure',
		allowBlank: false,
		minChars: 1,
		pageSize: 10,
		editable:true
	});



var DetailGrid = new dhc.herp.Gridhss({
	 title: '��Ŀ��λ������ϸ��Ϣ�б�',
		    iconCls: 'list',
			region : 'center',
			url : Url1,	
	       //view : new MyGridView(viewConfig),	
	        cm : colModel,
	        //selModel:sm,
	        readerModel:'remote',		
			fields :  [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			        {
				        id:'RowID',
						header : '��λ������ϢID',
						dataIndex : 'RowID',
						hidden : true
					},{
						id : 'rowid',
						header : '������Ϣid',
						width : 200,
						hidden : true,
						dataIndex : 'rowid'
					},
					{
						id : 'arriveexpenditure',
						header : '��λ����(��Ԫ)',
						width : 100,
						//editable:false,
						align:'right',
						dataIndex : 'arriveexpenditure',
						type: arriveexpenditure,
						allowBlank: false,
						renderer: function(val)
         				{
	        				val=val.replace(/(^\s*)|(\s*$)/g, "");
	         				val=Ext.util.Format.number(val,'0.00');
	         				val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         				return val?val:'';
		 				}

					},{
						id : 'recipient',
						header : '������',
						width : 60,
						//editable:false,
						allowBlank: false,
						dataIndex : 'recipient',
						type: user1Combo
					},{
       					id:'ArriveDate',
        				header: '��λʱ��',
        				width:80,
						//tip:true,
						allowBlank: false,
        				dataIndex: 'ArriveDate',
        				type:'dateField'
					},{
       					id:'FundSources',
        				header: '��Ŀ������Դ',
        				width:120,
						//tip:true,
						allowBlank: false,
        				dataIndex: 'FundSources',
        				type: FundSourcesField,
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
		
    				},{
       					id:'FundForm',
        				header: '������ʽ',
        				width:100,
						//tip:true,
						allowBlank: false,
        				dataIndex: 'FundForm',
        				type: FundFormField
    				},{
						id : 'midcheckFlag',
						header : '����״̬',
						width : 60,
						editable:false,
						dataIndex : 'midcheckFlag'

					},{
						id : 'midcheckState',
						header : '���״̬',
						width : 180,
						editable:false,
						dataIndex : 'midcheckState'

					},{
						id : 'midcheckopinion',
						header : '�������',
						width : 180,
						editable:false,
						//hidden:true,
						dataIndex : 'midcheckopinion'
           // type:grafundsField,//���ö������ֵ�ı���
					},{
						id : 'ApplyName',
						header : '¼����',
						editable:false,
						width : 60,
						dataIndex : 'ApplyName'
					},{
						id : 'MidDate',
						header : '¼��ʱ��',
						editable:false,
						width : 80,
						dataIndex :'MidDate'

					},{
						id : 'CheckName',
						header : '�����',
						width : 120,
						hidden : true,
						editable:false,
						dataIndex : 'CheckName'

					},{
						id : 'CheckDate',
						header : '���ʱ��',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'CheckDate'

					},{
						id : 'desc',
						header : '��ע˵��',
						width : 180,
						//editable:false,
						allowBlank: true,
						dataIndex : 'desc',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					}],
					//tbar:['-'],
					layout:"fit",
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',	
					loadMask: true,
					trackMouseOver: true,
					stripeRows: true
	            
             
		});
 
		//DetailGrid.btnAddHide();  //�������Ӱ�ť
		//DetailGrid.btnSaveHide();  //���ر��水ť
		//DetailGrid.btnResetHide();  //�������ð�ť
		//DetailGrid.btnDeleteHide(); //����ɾ����ť
		// DetailGrid.btnPrintHide();  //���ش�ӡ��ť
		//DetailGrid.addButton('-');
		DetailGrid.addButton(RewardApplyButton);
       // DetailGrid.load({params:{start:0, limit:25}});


