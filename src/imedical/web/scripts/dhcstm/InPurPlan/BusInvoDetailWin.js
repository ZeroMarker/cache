	///Creator:bianshuai
	///CreatDate:2014-04-24
	///Descript:历史进销窗体
	BusInvoDetailWin=function(inci,desc,locid){
		///初始化时间点
		var htmlstr="";
		var curyear=(new Date).getFullYear();
		var lastyear=(curyear-1)+"年";
		var blastdate=(curyear-2)+"年";
		var statdate=blastdate+"年 "+"-"+curyear+"年";
		curyear=curyear+"年";
		///窗体内容
		function AutoLoadHtmlPage(loc,inci)
		{
			//提取主信息
			var mytrn=tkMakeServerCall("web.DHCSTM.INPurPlan","getHistoryInvo",loc,inci);
			//if(mytrn==""){ return "<div align='center' style='color:#F00; font-size:50px'>数据提取错误！</div>";}
			//返回值为空时 直接赋空值
			if(mytrn==""){ mytrn="^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^&^^^^^^^";}
			var monthArr=mytrn.split("&");
			//画表格
			htmlstr="";
			htmlstr=htmlstr+"<div id='PageContent' height:'900'>";
			htmlstr=htmlstr+"<table border='0' width='500' class='tbl' cellspacing='1' cellpadding='0' bgcolor='#000000'>";
			htmlstr=htmlstr+"<tr align='center'><td bgcolor='#F0F0F0' rowspan=2 width='30' height='25'>月</td><td bgcolor='#F0F0F0' colspan='2' height='25'>"+blastdate+"</td><td bgcolor='#F0F0F0' colspan='2'>"+lastyear+"</td><td bgcolor='#F0F0F0' colspan='2'>"+curyear+"</td><td bgcolor='#F0F0F0' colspan='2'>合计</td></tr>";
			htmlstr=htmlstr+"<tr align='center'><td bgcolor='#F0F0F0' height='25'>入库</td><td bgcolor='#F0F0F0'>出库</td><td bgcolor='#F0F0F0'>入库</td><td bgcolor='#F0F0F0'>出库</td><td bgcolor='#F0F0F0'>入库</td><td bgcolor='#F0F0F0'>出库</td><td bgcolor='#F0F0F0'>入库</td><td bgcolor='#F0F0F0'>出库</td></tr>";
			var index="";
			for(var i=1;i<=13;i++){
				var strarr=monthArr[i-1].split("^");
				index=i;
				if(i==13){
					index="合计";
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
		
		///更新库存数量
		function SetLabelStkQty(loc,inci)
		{
			var stkqtyuom=tkMakeServerCall("web.DHCSTM.INPurPlan","GetLocCurrStk",loc,inci);
			Ext.getCmp('LocStkLabel').setText('<p style="font-weight:bold; color:red">'+"库存数："+stkqtyuom+'</p>',false);
		}
		
		///科室库存
		var LocStkLabel=new Ext.form.Label({
			id:'LocStkLabel',
			html:'<div style="color:#F00; font-weight=bold;">库存数：</div>',
			width:30
		})
		
		//统计科室
		var LocComBox = new Ext.ux.LocComboBox({
				fieldLabel : '科室',
				id : 'PhLoc',
				name : 'PhaLoc',
				anchor:'90%',
				groupId:''
		});
		
		LocComBox.on('select',function(){
			//根据科室更新页面内容
			var Loc=Ext.getCmp("PhLoc").getValue();
			var stkqtyuom=tkMakeServerCall("web.DHCSTM.INPurPlan","GetLocCurrStk",Loc,inci);
			///更新界面表格数据
			window.body.update(AutoLoadHtmlPage(Loc,inci));
			///更新库存数
			SetLabelStkQty(Loc,inci);
		})
		
		var window=new Ext.Window({
			title:'进销历史',
			width:515,
			height:480,
			resizable:false,
			tbar:['<div style="color:#F00; font-weight=bold;">'+desc+'</div>'],
			bbar:["科室:",LocComBox,'-',LocStkLabel]
		})
		
		///初始化界面表格
		window.html=AutoLoadHtmlPage(locid,inci);
		///初始化库存数
		SetLabelStkQty(locid,inci);
		///显示窗体
		window.show();
	}