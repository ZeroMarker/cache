	///Creator:bianshuai
	///CreatDate:2014-04-24
	///Descrip: ҵ����ϸ��Ϣ

	BusDetailWin=function(intr){
		
		function AutoLoadHtmlPage(intr)
		{
			//mk.show(); //��ʾ
			///׼����ʾ����
			var ret=tkMakeServerCall("web.DHCST.LocItmTransMove","QueryBusDetail",intr);
			var strArr=ret.split("^");
			var pid=strArr[0];
			var num=strArr[1];
			
			if(num<=1){
				//mk.hide(); //�ر�
				return "<div align='center' style='color:#15428b; font-size:30px'>"+$g("��ʱ�䷶Χ����ҵ�����ݣ�")+"</div>";}
			///��ȡ����Ϣ
			var mainstr=tkMakeServerCall("web.DHCST.LocItmTransMove","getTempPrintData",pid,"");
			Ext.getCmp('LocStkLabel').setText('<p style="font-weight:bold; color:#15428b; font-size:17;">'+mainstr+'</p>',false);
			///ȡ��ͷ
			var celnamestr=tkMakeServerCall("web.DHCST.LocItmTransMove","getTempPrintData",pid,1);
			var cellArr=celnamestr.split("^");
			var cellNum=cellArr.length;
	
			///�����
			htmlstr="";
			htmlstr=htmlstr+"<div id='PageContent' height:'900'>";	
			htmlstr=htmlstr+"<table border='0' class='tbl' width='1000' cellspacing='1' cellpadding='0' bgcolor='#000000'>";
	
			///������ͷ
	
			htmlstr=htmlstr+"<tr align='center'><td bgcolor='#F0F0F0' height='25' width='30'>"+$g("���")+"</td>";
			for(var k=0;k<cellNum;k++)
			{
				if(k==0){width='70';}
				if(k==1){width='50';}
				if(k==2){width='50';}
				if(k==3){width='50';}
				if(k==4){width='100';}
				if(k==5){width='100';}
				if(k==6){width='50';}
				if(k==7){width='60';}
				if(k==8){width='50';}
				if(k==9){width='60';}
				htmlstr=htmlstr+"<td bgcolor='#F0F0F0' width='"+width+"'>"+cellArr[k]+"</td>";
			}
			htmlstr=htmlstr+"</tr>";
			
			
			var tmp="0145";
			///����
			for(var i=2;i<=num;i++)
			{
				///��ȡ����Ϣ
				var detailstr=tkMakeServerCall("web.DHCST.LocItmTransMove","getTempPrintData",pid,i);
				var detailArr=detailstr.split("^");
				index=i-1;
				htmlstr=htmlstr+"<tr><td bgcolor='#F0F0F0' align='center' height='25'>"+index+"</td>";
				for(var j=0;j<detailArr.length;j++)
				{
					action="center";
					if(tmp.indexOf(j)==-1){action='center'}  ///0145�п�����ʾ ����������ʾ
					htmlstr=htmlstr+"<td bgcolor='#F0F0F0' align='"+action+"'>"+detailArr[j]+"</td>"
				}
				htmlstr=htmlstr+"</tr>";
			}
			
			htmlstr=htmlstr+"</tabel>";
			htmlstr=htmlstr+"</div>";
			///k����ʱglobal
			var ret=tkMakeServerCall("web.DHCST.LocItmTransMove","killTempGlobal",pid);
			//mk.hide(); //�ر�
			return htmlstr;
		}
		
		///���ҿ��
		var LocStkLabel=new Ext.form.Label({
			id:'LocStkLabel',
			html:'<div style="color:#F00; font-weight=bold;"></div>',
			width:30
		})
		var mk = new Ext.LoadMask(document.body, {  
			msg: $g('���ڲ������ݣ����Ժ�'),  
			removeMask: true //��ɺ��Ƴ�  
		});
		var window=new Ext.Window({
			title:$g('ҵ�񵥾���ϸ'),
			width:document.body.clientWidth*0.77,
			height:document.body.clientHeight*0.8,
			resizable:false,
			tbar:[LocStkLabel],
			closeAction: 'close' ,
			autoScroll: true //�Զ���ʾ������
		})
	
		///��ʼ��������
		window.html=AutoLoadHtmlPage(intr);
		window.show();
	}