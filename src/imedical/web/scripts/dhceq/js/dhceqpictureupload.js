//GR0033 extjs ͼƬ�ϴ�
//����ͼƬ�ϴ�ģ̬����
//����csp��dhceq.process.picture.csp
//=========================�Ӵ���=============================
function CreatePicuploadWin(PictureData,PiclistData)
{
	var TSourceType=PictureData.TSourceType
	//==========================================�ؼ�=====================================
	var PicformPicType=	new Ext.dhceq.PicTypeComboBox({id:'PicformPicType',hiddenName:'PicTypeDR',SourceType:CurrentSourceType,allowBlank:false});
	PicformPicType.store.load(
			{params:{start:0,limit:20},
			callback : function(r, options, success) {
				SetPictureInfo()
			},
			scope: CreatePicuploadWin, //Scope����ָ���ص�����ִ��ʱ��������
           	//AddΪtrueʱ��load()�õ������ݻ������ԭ����store���ݵ�ĩβ��
          	//����������֮ǰ�����ݣ��ٽ��õ���������ӵ�store��
����add: false //ensemble��js�������Կհ״���̫����
	})
var PicformPicNo=	new Ext.form.TextField({		
					id:'PicformPicNo',
					name:'PictureNo',
					fieldLabel: 'ͼƬ���',
					selectOnFocus:true
				  }); 
var PicformPicName=	new Ext.form.TextField({		
					id:'PicformPicName',
					name:'PicName',
					fieldLabel: 'ͼƬ����',
					allowBlank:false,
					selectOnFocus:true
				  });			           	
var PicformRemark=	new Ext.form.TextField({		
					id:'PicformRemark',
					name:'Remark',
					fieldLabel: '��ע',
					selectOnFocus:true
				  });
var PicformLocation=	new Ext.form.TextField({		
					id:'PicformLocation',
					name:'Location',
					fieldLabel: '���λ��',
					selectOnFocus:true
				  });
var PicformSort=new Ext.form.NumberField({
	id:'PicformSort',
	name:'PicSort',
    fieldLabel:"���",
    allowDecimals:false,  //����������С��
    nanText:"��������Ч����", //��Ч������ʾ
    allowNegative:false       //���������븺��
    ,width : 100,
    allowBlank:false,       //������Ϊ��        modified by czf ����ţ�357126
    disabled:""!=PictureData,
	listWidth : 100,
	textWidth:100
   })
var PicformDefaultFlagField = new Ext.form.Checkbox({
	id : "PicformDefaultFlagField",
	name : "DefaultFlag",
	boxLabel : "Ĭ����ʾ",
	inputValue : "Y",
	height:40,
	anchor : "90%",
	hideLabel : true
	//Ϊcheckbox���ѡ���¼�
}); 
	
//============================���==========================

	
	//�������
	var PicformPanel = new Ext.form.FormPanel({
	labelwidth : 30,
	autoScroll:true,
	//Height:500,
	labelAlign : 'right',
	frame : true,
	bodyStyle : 'padding:5px;',
	fileUpload:""==PictureData, 	//3.3�汾��������������ԣ�4.2�ƺ�����
    items : [{
		//xtype : 'fieldset',
		//title : '�ϴ�ѡ��',
		//autoHeight : true,
		//layout : 'column',
		// add by zx 20190107 ���������� �����:773586 			
		items : [{
				layout : 'column',
				items : [
					{columnWidth : .50,layout:'form',items :PicformPicName,height:40},
					{columnWidth : .50,layout:'form',items :PicformPicType,height:40}
					
				]},{
				layout : 'column',
				items : [
					{columnWidth : .50,layout:'form',items :PicformPicNo,height:40},
					{columnWidth : .50,layout:'form',items :PicformRemark,height:40}
					
				]},{
				layout : 'column',
				items : [
					{columnWidth : .50,layout:'form',items :PicformLocation,height:40},
					{columnWidth : .15,layout:'form',items :PicformDefaultFlagField,height:40},
					{columnWidth : .35,layout:'form',items :PicformSort,height:40}
				]},{
				layout : 'column',
				hidden:""!=PictureData,
				items : [
				{
					columnWidth : .55,
					//width:300,
					style : 'margin:0px 0px 0px 4%;',//{top:0, right:0, bottom:0, left:0}
					xtype: 'textfield',   
					fieldLabel: '�� ��',   
					name: 'FileStream' ,  
					inputType: 'file',  
					disabled:""!=PictureData,
					allowBlank: false,  //modify by lmm 2017-07-17 413570
					blankText: '���ϴ��ļ�',   
					anchor: '90%' 
					}	//,{columnWidth : .13,layout:'form',items :PicformDefaultFlagField}//{width:100,items :PicformSort}//,{columnWidth : .66,layout:'form',width:100,items :checkboxModule}
					
				]},{
				layout : 'column',
				items : [{
					disabled:(TSourceType!=CurrentSourceType)&&(PictureData!=""),
					style : 'margin:10px 0px 0px 5%;',
					xtype: 'button',//Ϊ�˷������Ƕ�ף�buttonҪд��items��[]���治��д��button��[]����
					iconCls:'page_edit',
					text: '����',
					handler:formhandler //����Ensemble��js�༭��Ч�ʵ��£�������������Ƶ�����
				}
				]
				}
		]
	}]
});
	function formhandler() 
	{
		var form = this.findParentByType("form").getForm();
		var PLRowID ="",PTRowID =""
		if (undefined!=PictureData.TRowID) PTRowID = PictureData.TRowID
		if (undefined!=PicListGrid.TRowID) PLRowID = PiclistData.TRowID;
		if(form.isValid()){
			form.submit({
				url: '../csp/dhceq.process.pictureaction.csp?&actiontype=UploadByFtpStream&SourceType='+CurrentSourceType+'&SourceID='+CurrentSourceID+'&PTRowID='+PTRowID+'&PLRowID='+PLRowID+'&EquipDR='+EquipDR,		//3.3�汾URlд������
				waitMsg: 'Uploading your file...',
				success: function(form, action)
				{
					Msg.info("",'Success' + action.result.result)
					UpdateForPicChange()
					PicSimpleuploadWinwindow.close();  // And By QW20180312 �����545974,545983
					//PicListGrid.store.load({params:{start:0,limit:PicListPagingToolbar.pageSize}})
				},
				failure: function(form, action) 
				{
					Msg.info("error",'failure'  + action.result.result)
				}
			});
			
		}
		else Msg.info("error","����ȫ")
	}
	//========================����========================
	
	//��ʼ������
	var PicSimpleuploadWinwindow = new Ext.Window({
		title:'��ͼƬ��Ϣ',
		width:800,  // add by zx 20190107 ���������� �����:773586 
		height:250,
		minWidth:600,
		minHeight:400,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle :'overflow-x:hidden;overflow-y:scroll',//����ˮƽ��������ֹ����ͼƬʱ�ڲ����̫��
		items:[PicformPanel],
		
		listeners:{
			'close':function(){
				}
			}
	});
	
	
	PicSimpleuploadWinwindow.show();	//��window�Ŀؼ�����д��һ��js�����в�ͨ������������������Լ��ɵ�windowFramԪ��û����ȫɾ���й�
	//==============================���ܺ���==================================
	function SetPictureInfo()
	{
		if (PictureData!="")
		{
			Ext.getCmp('PicformPicType').setValue(PictureData.TPicTypeDR)
			Ext.getCmp('PicformPicNo').setValue(PictureData.TPicNo)
			Ext.getCmp('PicformLocation').setValue(PictureData.TPicLocation)
			Ext.getCmp('PicformRemark').setValue(PictureData.TRemark)
			Ext.getCmp('PicformPicName').setValue(PictureData.TPicName)
			Ext.getCmp('PicformSort').setValue(PictureData.PicformSort)
		}
	}
//========================��ʼ��===========================

	
	
	
}
