(function(){
	Ext.ns("dhcwl.RptMgmt.MgmtShowTemplate");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.RptMgmt.MgmtShowTemplate=function(pObj){
	var serviceUrl="dhcwl/rptmgmt/showmain.csp";
	// Some sample html
	/*
	var html = [
		'<h1>报表功能说明</h1>',
		'<h2>Heading Two</h2>',
		'<p>This is a paragraph with <strong>STRONG</strong>, <em>EMPHASIS</em> and a <a href="#">Link</a></p>',
		'<table>',
			'<tr>',
				'<td>Table Column One</td>',
				'<td>Table Column Two</td>',
			'</tr>',
		'</table>',
		'<ul>',
			'<li>Un-ordered List-item One</li>',
			'<li>Un-ordered List-item One</li>',
		'</ul>',
		'<ol>',
			'<li>Ordered List-item One</li>',
			'<li>Ordered List-item Two</li>',
		'</ol>',
		'<blockquote>This is a blockquote</blockquote>'
	];
	*/
	
	


	var templateWin = new Ext.Window({
        width:700,
		height:550,
		resizable:false,
		closable : false,
		title: '报表功能说明',
		modal:true,
		//items:templatePanel ,		
		layout:'fit',
				
		buttons: [
		{
			text: '<span style="line-Height:1">关闭</span>',
			icon   : '../images/uiimages/cancel.png',
			handler: CloseWin
		}]
	});	
	
	function CloseWin() {
			templateWin.close();
	}	

	var html = [];	
	function loadMgmtData(RaqName,CSPName,AuxiliaryMenuName) {
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:"GetRptCfg",
			RaqName: RaqName,
			CSPName: CSPName,
			AuxiliaryMenuName:AuxiliaryMenuName
		},function(jsonData){
			//if(jsonData.success==true && jsonData.tip=="ok"){
			if(!!jsonData.root){
				var repDatas=jsonData.root[0];
				//<p align="center">我的青春 </p>
				html.push('<h1 align="center">报表/产品说明</h1>');
						html.push('<hr>');
				html.push('<ul>');
				html.push('<h3>报表或产品的备忘说明。  </h3>');
				html.push('<li><strong>raq文件:</strong> '+ repDatas.RaqName   +'  </li>');
				html.push('<br>');
				html.push('<li><strong>当前页面(标题)名称:</strong> '+ repDatas.AuxiliaryMenuName   +'  </li>');
				html.push('<br>');				
				
				html.push('<li><strong>csp文件:</strong> '+ repDatas.CSPName   +'  </li>');	
				html.push('<br>');			
				html.push('<li><strong>主程序query:</strong> '+ repDatas.QueryName   +'  </li>');
				html.push('<br>');
				html.push('<li><strong>统计口径:</strong> '+ repDatas.Spec   +'  </li>');						
				html.push('<br>');
				html.push('<li><strong>业务表:</strong> '+ repDatas.HisTableName   +'  </li>');
				html.push('<br>');
				html.push('<li><strong>使用指标:</strong> '+ repDatas.KPIName   +'  </li>');	
				html.push('<br>');
				html.push('<li><strong>数据条件:</strong> '+ repDatas.Filter   +'  </li>');
				html.push('<br>');
				html.push('<li><strong>显示条件:</strong> '+ repDatas.RowColShow   +'  </li>');	
				html.push('<br>');
				html.push('<li><strong>逻辑说明:</strong> '+ repDatas.ProgramLogic   +'  </li>');
				html.push('<br>');
				html.push('<li><strong>其他备注:</strong> '+ repDatas.Demo   +'  </li>');	
				html.push('<br>');
				html.push('<li><strong>高级客户:</strong> '+ repDatas.AdvUser   +'  </li>');
				html.push('<br>');
				html.push('<li><strong>项目工程师:</strong> '+ repDatas.ProMaintainer   +'  </li>');	
				html.push('<br>');
				html.push('<li><strong>开发工程师:</strong> '+ repDatas.DepMaintainer   +'  </li>');
				html.push('<br>');
				html.push('<li><strong>使用（科室）部门:</strong> '+ repDatas.UsedByDep   +'  </li>');	
				
				html.push('</ul>');
				
				var templatePanel=new Ext.Panel({
					preventBodyReset: true,
					autoScroll : true,
					//width: 400,
					html: html.join('')
				});				
				
				templateWin.add(templatePanel);

				templateWin.show();
			}else{
				//Ext.Msg.alert("操作失败",jsonData.MSG);
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);	
	}	
	
	function loadHyperlinkData(raqName,CSPName,AuxiliaryMenuName) {
		
		
		html.push('<h1 align="center">超链接文本</h1>');
		html.push('<hr>');
		html.push('<p style="font-size: 14px;text-indent:2em;">生成的超链接文本如下：</p>');
				html.push('</br>');
		html.push('<p style="font-size: 15px;text-indent:2em;">');
		html.push("\"javascript:cpm_showWindow('DTHealth-DHCWL-报表管理帮助.raq','inRaqName="+raqName+"&inCSPName="+CSPName+"&inAuxiliaryMenuName="+AuxiliaryMenuName+"')\"");
		html.push('<\p>');
		html.push('</br>');
		html.push('<p style="font-size: 14px;text-indent:2em;">可以将该文本复制到润乾文件中，作为超链接表达式的值</p>');
		var templatePanel=new Ext.Panel({
			preventBodyReset: true,
			//width: 400,
			html: html.join('')
		});				
		
		
		templateWin.add(templatePanel);
		templateWin.show();	
	}
	

	this.showMgmtDataWin =function(raqName,CSPName,AuxiliaryMenuName){
		loadMgmtData(raqName,CSPName,AuxiliaryMenuName);
	}
	
	this.showHyperlinkWin =function(raqName,CSPName,AuxiliaryMenuName){
		loadHyperlinkData(raqName,CSPName,AuxiliaryMenuName);
	}
	
	
	
	
	
	
}