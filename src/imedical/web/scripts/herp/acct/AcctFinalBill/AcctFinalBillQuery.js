 //=================================���ӱ���Query==========================//
  
	function Query(){
		var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
	    var tempId = acctTemplet.getValue();
		

		//����У��
		if(period==""){
			Ext.Msg.show({title:'����',msg:'����ڼ䲻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			
		}else if(tempId==""){
			Ext.Msg.show({title:'����',msg:'��֧��תģ�岻��Ϊ��',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else{
		    //===============================��ʾ����=============================//
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			//��ȡ����·��
			//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
			p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.InOutPayment.raq&period='+period+
						'&tempId='+tempId;
			
			reportFrame.src=p_URL;
		}
	}