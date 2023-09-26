selection = function(type){
	var titleName="";
	if(type==1){
		titleName="ָ�괰��";
	}else{
		titleName="��Ч��Ԫ����";
	}
	if(type==""){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		var userCode = session['LOGON.USERCODE'];
		var sm = new Ext.grid.CheckboxSelectionModel();
		var grid="";
		if(type==1){
			//type=1,���ָ��
			var KPIUrl = '../csp/dhc.pa.jxgroupexe.csp';
			var KPIProxy= new Ext.data.HttpProxy({url:KPIUrl + '?action=kpi'});
			var KPIDs = new Ext.data.Store({
				proxy: KPIProxy,
				reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['KPIDr','KPIName']),
				remoteSort: true
			});
			//����Ĭ�������ֶκ�������
			KPIDs.setDefaultSort('KPIDr', 'desc');
			//���ݿ�����ģ��
			var KPICm = new Ext.grid.ColumnModel([
				sm,
				new Ext.grid.RowNumberer(),
				{header:'ָ������',dataIndex:'KPIName',width:325}
			]);
			var grid = new Ext.grid.GridPanel({
				store:KPIDs,
				cm:KPICm,
				trackMouseOver: true,
				stripeRows: true,
				sm:sm,
				loadMask: true
			});
			KPIDs.load({params:{userCode:userCode}});
		}else{
			//type=2,��Ӽ�Ч��Ԫ
			//========================================================================
			//���һ���������
			var unitTypeDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['deptID','deptName'])
			});

			unitTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'dhc.pa.jxgroupexe.csp?action=unittype&str='+Ext.getCmp('unitType').getRawValue(),method:'POST'})
			});

			var unitType = new Ext.form.ComboBox({
				id:'unitType',
				fieldLabel:'��Ч��Ԫ���',
				width:240,
				listWidth : 240,
				allowBlank:true,
				store:unitTypeDs,
				valueField:'deptID',
				displayField:'deptName',
				emptyText:'��ѡ��Ч��Ԫ���...',
				triggerAction:'all',
				name: 'unitType',
				emptyText:'',
				minChars:1,
				pageSize:10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true
			});
			
			unitType.on("select",function(cmb,rec,id ){
				deptDs.load({params:{unitTypeDr:cmb.getValue()}});
			
			});
			//========================================================================
			var deptUrl = '../csp/dhc.pa.jxgroupexe.csp';
			var deptProxy= new Ext.data.HttpProxy({url:deptUrl + '?action=getJXUnit'});
			var deptDs = new Ext.data.Store({
				proxy: deptProxy,
				reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['deptID','deptName']),
				remoteSort: true
			});
			//����Ĭ�������ֶκ�������
			deptDs.setDefaultSort('deptID', 'desc');
			deptDs.on('load',function(){
		
				});
			//���ݿ�����ģ��
			var deptCm = new Ext.grid.ColumnModel([
				sm,
				new Ext.grid.RowNumberer(),
				{header:'��Ч��Ԫ����',dataIndex:'deptName',width:325}
			]);
			var str="��Ԫ���";
			
			var label = new Ext.form.Label
          ({
              id:"labelID",
              
              text:"��ѡ��������:",
              
              height:100,//Ĭ��auto
              
              width:100,//Ĭ��auto
              
              autoShow:true,//Ĭ��false
              
              autoWidth:true,//Ĭ��false
              
              autoHeight:true,//Ĭ��false
              
              hidden:false,//Ĭ��false
              
              hideMode:"offsets",//Ĭ��display,����ȡֵ��display��offsets��visibility
              
              cls:"cssLabel",//��ʽ����,Ĭ��""
              
              disabled:true,//Ĭ��false
              disabledClass:"",//Ĭ��x-item-disabled
              
              html:"Ext"//Ĭ��""
              
              //x:number,y:number,�������е�x,y����
             
              
          });
			var grid = new Ext.grid.GridPanel({
				store:deptDs,
				cm:deptCm,
				//trackMouseOver: true,
				//stripeRows: true,
				sm:sm,
				region: 'center',
				layout:'fit',
				tbar:[label,"&nbsp&nbsp&nbsp",unitType]
	
			});
			//deptDs.load();
		}
		
		var OkButton = new Ext.Toolbar.Button({
				text:'ȷ��'
			});
		//���尴ť��Ӧ����
		OkHandler = function(){
			var rowObj=grid.getSelections();
			var len = rowObj.length;
			var idStr="";
			var nameStr="";
			if(len < 1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				if(type==1){
					for(var i=0;i<len;i++){
						KPIDr=rowObj[i].get("KPIDr");
						if(idStr==""){
							idStr=KPIDr;
						}else{
							idStr=idStr+"-"+KPIDr
						}
						KPIName=rowObj[i].get("KPIName");
						if(nameStr==""){
							nameStr=KPIName;
						}else{
							nameStr=nameStr+"-"+KPIName;
						}
					}
					IDSet.setValue(nameStr);
					KPIDrStr=idStr;
					KPINameStr=nameStr;
					deptNameStr="";
					deptIDStr="";
				}else{
					for(var i=0;i<len;i++){
						deptID=rowObj[i].get("deptID");
						if(idStr==""){
							idStr=deptID;
						}else{
							idStr=idStr+"-"+deptID
						}
						deptName=rowObj[i].get("deptName");
						if(nameStr==""){
							nameStr=deptName;
						}else{
							nameStr=nameStr+"-"+deptName;
						}
					}
					IDSet.setValue(nameStr);
					deptIDStr=idStr;
					deptNameStr=nameStr;
					KPINameStr="";
					KPIDrStr="";
				}
				win.close();
			}
		}
			
		//��Ӱ�ť�ļ����¼�
		OkButton.addListener('click',OkHandler,false);
		
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
		
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			win.close();
		}
		
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
		
		var win = new Ext.Window({
			title:titleName,
			width:420,
			height:450,
			minWidth: 420, 
			minHeight: 450,
			layout: 'fit',
			plain:true,
			modal:true,
			//bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items:grid,
			buttons: [
				OkButton,
				cancelButton
			]
		});

		//������ʾ
		win.show();
	}
}