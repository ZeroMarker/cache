	///Creator:bianshuai
	///CreatDate:2014-04-24
	///Descript:��ʷ��������
	BusInvoDetailWin=function(inci,desc,locid){
		///��ʼ��ʱ���
		var htmlstr="";
		var curyear=(new Date).getFullYear();
		var lastyear=(curyear-1)+"��";
		var blastdate=(curyear-2)+"��";
		var statdate=blastdate+"�� "+"-"+curyear+"��";
		curyear=curyear+"��";
		///��������
		function AutoLoadHtmlPage(loc,inci)
		{
			//��ȡ����Ϣ
			var mytrn=tkMakeServerCall("web.DHCSTM.INPurPlan","getHistoryInvo",loc,inci);
			//if(mytrn==""){ return "<div align='center' style='color:#F00; font-size:50px'>������ȡ����</div>";}
			//����ֵΪ��ʱ ֱ�Ӹ���ֵ
			if(mytrn==""){ mytrn="^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^";}
			var monthArr=mytrn.split("&");
			//�����
			htmlstr="";
			htmlstr=htmlstr+"<div id='PageContent' height:'900'>";
			htmlstr=htmlstr+"<table border='0' width='500' class='tbl' cellspacing='1' cellpadding='0' bgcolor='#000000'>";
			htmlstr=htmlstr+"<tr align='center'><td bgcolor='#F0F0F0' rowspan=2 width='30' height='25'>��</td><td bgcolor='#F0F0F0' colspan='2' height='25'>"+blastdate+"</td><td bgcolor='#F0F0F0' colspan='2'>"+lastyear+"</td><td bgcolor='#F0F0F0' colspan='2'>"+curyear+"</td><td bgcolor='#F0F0F0' colspan='2'>�ϼ�</td></tr>";
			htmlstr=htmlstr+"<tr align='center'><td bgcolor='#F0F0F0' height='25'>���</td><td bgcolor='#F0F0F0'>����</td><td bgcolor='#F0F0F0'>���</td><td bgcolor='#F0F0F0'>����</td><td bgcolor='#F0F0F0'>���</td><td bgcolor='#F0F0F0'>����</td><td bgcolor='#F0F0F0'>���</td><td bgcolor='#F0F0F0'>����</td></tr>";
			var index="";
			for(var i=1;i<=13;i++){
				var strarr=monthArr[i-1].split("^");
				index=i;
				if(i==13){
					index="�ϼ�";
					}
				htmlstr=htmlstr+"<tr align='right'><td bgcolor='#F0F0F0' align='center' height='25'>"+index+"</td>";
				for(var j=0;j<strarr.length;j++)
				{
					htmlstr=htmlstr+"<td bgcolor='#F0F0F0'>"+strarr[j]+"</td>";	
				}
				htmlstr=htmlstr+"</tr>";
			}
			htmlstr=htmlstr+"</tabel>";
			htmlstr=htmlstr+"</div>";
			return htmlstr;
		}
		
		///���¿������
		function SetLabelStkQty(loc,inci)
		{
			var stkqtyuom=tkMakeServerCall("web.DHCSTM.INPurPlan","GetLocCurrStk",loc,inci);
			Ext.getCmp('LocStkLabel').setText('<p style="font-weight:bold; color:red">'+"�������"+stkqtyuom+'</p>',false);
		}
		
		///���ҿ��
		var LocStkLabel=new Ext.form.Label({
			id:'LocStkLabel',
			html:'<div style="color:#F00; font-weight=bold;">�������</div>',
			width:30
		})
		
		//ͳ�ƿ���
		var LocComBox = new Ext.ux.LocComboBox({
				fieldLabel : '����',
				id : 'PhLoc',
				name : 'PhaLoc',
				anchor:'90%',
				groupId:''
		});
		
		LocComBox.on('select',function(){
			//���ݿ��Ҹ���ҳ������
			var Loc=Ext.getCmp("PhLoc").getValue();
			var stkqtyuom=tkMakeServerCall("web.DHCSTM.INPurPlan","GetLocCurrStk",Loc,inci);
			///���½���������
			window.body.update(AutoLoadHtmlPage(Loc,inci));
			///���¿����
			SetLabelStkQty(Loc,inci);
		})
		
		var window=new Ext.Window({
			title:'������ʷ',
			width:515,
			height:480,
			resizable:false,
			tbar:['<div style="color:#F00; font-weight=bold;">'+desc+'</div>'],
			bbar:["����:",LocComBox,'-',LocStkLabel]
		})
		
		///��ʼ��������
		window.html=AutoLoadHtmlPage(locid,inci);
		///��ʼ�������
		SetLabelStkQty(locid,inci);
		///��ʾ����
		window.show();
	}