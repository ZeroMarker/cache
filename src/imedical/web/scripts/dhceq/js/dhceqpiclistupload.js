//=========================�Ӵ���=============================

//�����༭����(����)
//rowid :��Ӧ��rowid
function CreatePicListuploadWin(PictureData,PiclistData)
{
	if (undefined==PictureData.TRowID) {Msg.info("error","��ѡ������");return}
	var TSourceType=PictureData.TSourceType
	if ((TSourceType!=CurrentSourceType)&&(PictureData!="")) {Msg.info("error","�������ҵ��¼����");return}
	//==========================================�ؼ�=====================================
	var PicListuploadWinPicSort=new Ext.form.NumberField({
		id:'PicListuploadWinPicSort',
		name:'PicSort',
    	fieldLabel:"���",
    	allowDecimals:false,  //����������С��
    	nanText:"��������Ч����", //��Ч������ʾ
    	allowNegative:false,       //���������븺��
    	width : 100,
		listWidth : 100,
		textWidth:100
   })
	var PicListuploadWinDefaultFlagField = new Ext.form.Checkbox({
		id : "PicListuploadWinDefaultFlagField",
		name : "DefaultFlag",
		autoScroll : false,
		width : 90,
		boxLabel : "Ĭ����ʾ",
		inputValue : "Y",
		anchor : "90%",
		hideLabel : true
		//Ϊcheckbox���ѡ���¼�
}); 	
//============================���==========================

	
	//�������
	var PicListuploadWinformPanel = new Ext.form.FormPanel({
		autoScroll:true,
		labelAlign : 'right',
		frame : true,
		region:'center',
		Height:150,
		style : 'margin:0px 0px 0px 0px;',
		//bodyStyle : 'padding:5px;',
		fileUpload:true, 	//3.3�汾��������������ԣ�4.2�ƺ�����
		items : [{
			//layout : 'column',���򣬿ؼ�̫��ᵼ��ǿ�ƻ��У�columnWidth : .33������Ч
			xtype : 'fieldset',
			title : 'ͼƬ�ϴ�',
			Height:150,	
			//autoHeight : true,
			//layout:'form',		
			items : [{
				layout : 'column',
				items : [
					{columnWidth : .50,layout:'form',items :PicListuploadWinPicSort},
					{columnWidth : .50,layout:'form',items :PicListuploadWinDefaultFlagField}
				]},{
				layout : 'column',
				items : [
				{
					columnWidth : .50,
					style : 'margin:0px 0px 0px 4%;',//{top:0, right:0, bottom:0, left:0}
					xtype: 'textfield',   
					fieldLabel: '�� ��',   
					name: 'FileStream' ,  
					inputType: 'file',   
					blankText: '���ϴ��ļ�',   
					anchor: '90%' 
				},{
					style : 'margin:0px 0px 0px 4%;',
					xtype: 'button',//Ϊ�˷������Ƕ�ף�buttonҪд��items��[]���治��д��button��[]����
					text: '����',
					disabled:(TSourceType!=CurrentSourceType)&&(PictureData!=""),
					handler:PicListuploadhandler 
				 }]
			}]
		}]
	});
	function PicListuploadhandler() 
					{
						var form = this.findParentByType("form").getForm();
						var PLRowID ="",PTRowID =""
						if (undefined!=PictureData.TRowID) PTRowID = PictureData.TRowID
						if (undefined!=PiclistData.TRowID) PLRowID = PiclistData.TRowID;
						if(form.isValid()){
							form.submit({
								url: '../csp/dhceq.process.pictureaction.csp?&actiontype=UploadByFtpStream'+'&PTRowID='+PTRowID+'&PLRowID='+PLRowID,		
								waitMsg: 'Uploading your file...',
								success: function(form, action)
								{
									Msg.info("",'Success' + action.result.result)
									UpdateForPicListChange()
								},
								failure: function(form, action) 
								{
									Msg.info("error",'failure'  + action.result.result)
								}
							});
						}
					}
	//========================����========================
	
	//��ʼ������
	var PicListuploadWinwindow = new Ext.Window({
		title:'ͼƬ��ϸ�ϴ�',
		width:550,
		height:150,
		minWidth:600,
		minHeight:400,
		//layout:'fit',
		plain:true,
		modal:true,
		layout:'border',
		//autoScroll:true,
		bodyStyle :'overflow-x:hidden;overflow-y:scroll',//����ˮƽ��������ֹ����ͼƬʱ�ڲ����̫��
		items:[PicListuploadWinformPanel]
	});
	
	
	PicListuploadWinwindow.show();	//��window�Ŀؼ�����д��һ��js�����в�ͨ������������������Լ��ɵ�windowFramԪ��û����ȫɾ���й�
	//==============================���ܺ���==================================
	//=====================��ʼ��=====================
	function SetPiclistInfo()
	{
		if (PiclistData!="")
		{
			Ext.getCmp('PicListuploadWinPicSort').setValue(PiclistData.TPicListSort)
			Ext.getCmp('PicListuploadWinDefaultFlagField').setValue(PiclistData.TDefaultFlag)
		}
	}
	SetPiclistInfo()
	
	
	
	
	
		
	
	
}