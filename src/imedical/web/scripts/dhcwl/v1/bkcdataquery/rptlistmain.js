$(function(){

		///主界面查询响应方法
	$('#searchBtn').searchbox({
		searcher:function(value){
			GetRptList(value);

		}
	})	
	
	function addTab(item){
		var windowHeight=window.innerHeight;
		//取到父窗口的原始：window.parent.$HUI
		//var tabs=window.parent.$HUI.tabs("#maintabs");
		var tabs=window.parent.$HUI.tabs("#homepage");
		var TAB_CONTTEMP=[
		    '<iframe id="',
		    , 
		    '"name="',
		    , 
		    '" frameborder="0" marginheight="0px" marginwidth="0px" scrolling="auto" seamless="seamless"  src="',
		    , 
		    '" height="',
		    , 
		    'px" width="',
		    , 
		    '"></iframe>'
		  ];
		TAB_CONTTEMP[7]=window.innerHeight;
		TAB_CONTTEMP[9]="100%";		
			
		var $href=item;
		var openTab=tabs.getTab($href.attr("data-title"));
		if(tabs.exists($href.attr("data-title"))){
			tabs.select($href.attr("data-title"));
			return true;
		}
		TAB_CONTTEMP[1]=$href.attr("data-code");
		TAB_CONTTEMP[3]=$href.attr("data-code");
		TAB_CONTTEMP[5]="/dthealth/web/csp/dhcwlredirect.csp?url="+$href.attr("data-url");
		var tabcontent=TAB_CONTTEMP.join('');
		tabs.add({
			"id":$href.attr("data-code"),
			"selected":true,
			"closable":true,
			"cache":false,
			"width":"auto",
			"title":$href.attr("data-title"),
			"content":TAB_CONTTEMP.join('')
		});		
	} 
	
	function GetRptList(searchV) {
		$cm({
			ClassName:"DHCWL.PerMis.Interface",
			//MethodName:"GetBKCRptList",
			QueryName:"GetRptSummaryByUrer",	
			wantreturnval:0,
			userID:userID,
			rptTool:"all",
			searchV:searchV
			
			},function(jsonData){
				//清空之前的报表列表
				$(".recentlist").empty();
				$(".income").empty();
				$(".reg").empty();
				$(".oit").empty();
				$(".mr").empty();
				$(".opera").empty();
				
				if(jsonData.total>0){
					var aryData=jsonData.rows;
					var toolName="";
					for(var i=0;i<aryData.length;i++){
						var item=aryData[i];
						var typedescript='';
						if (item.toolName=='cdq') {
							typedescript='简单数据查询报表';
							toolName="CommonDataQuery";
						}else if (item.toolName=='bdq') {
							typedescript='基础数据查询报表';
							toolName="BaseDataQuery";
						}else if (item.toolName=='kdq') {					
							typedescript='指标数据查询报表';
							toolName="KpiDataQuery";
						}else if (item.toolName=='odq') {
							typedescript='其他查询报表';
						};
						var btypeCode=""
						if (item.businessType=="") btypeCode=".other";
						else if (item.businessType=="最近访问报表") btypeCode=".recentlist";
						else if (item.businessType=="收入") btypeCode=".income";
						else if (item.businessType=="挂号") btypeCode=".reg";
						else if (item.businessType=="出入转") btypeCode=".oit";
						else if (item.businessType=="病案") btypeCode=".mr";
						else if (item.businessType=="手术") btypeCode=".opera";
						
	                    var html=[];
						html.push('<li class="item">');
	                    html.push('<img src ="../scripts_lib/hisui-0.1.0/dist/css/icons/big/book_arrow_rt.png" align ="left">');
	                    html.push('<a class="app-item-title"  href="javascript:void(0)" data-code="'+toolName+'-'+ item.ID +'" data-url="dhcwl/v1/bkcdataquery/bkcdataqryview.csp?rpttool='+toolName+'&rptid='+item.ID+'" data-title="'+item.title+'">');
	                    html.push('<p class="line-limit-length">&nbsp;'+item.title+'</p></a>');
	                    html.push('<a href="#" title="编码：'+item.code+'\n名称：'+item.title+'\n描述：'+item.descript+'\n使用['+typedescript+']工具，'+'\n由['+item.author+']制作。'+' " class="hisui-tooltip" data-options="position:\'right\'">');
	                    html.push('<p class="line-limit-length">&nbsp;编码['+item.code+']</p>');
	                    html.push('</a>');
               			html.push('</li>');
               			
               			$(html.join('')).appendTo(btypeCode);	
					}
					
					
					$(".app-item-title").click(function(e){
						if (1) {
							var url=$(this).attr("data-url");
							var ID=$(this).attr("data-code");
							var title=$(this).attr("data-title");
							var realUrl = "dhcwlredirect.csp?url=" + url;

							var realUrl = "dhcwlredirect.csp?url=" + url;
							/*if (window.opener.productWindowOpen.hasOwnProperty(ID)){
								obj = window.opener.productWindowOpen[ID];
								if (!obj.closed){
									obj.focus();
									return;
								}
							}*/
							
							var obj = window.open(realUrl,title,' left=20,top=20,width='+ (window.screen.availWidth - 60) +',height='+ (window.screen.availHeight-90) +',scrollbars,resizable=no,toolbar=no,depended=yes,menubar=no,location=no, status=no');
							//window.opener.productWindowOpen[ID] = obj;
						}else{
							 if (window.opener && !window.opener.closed) {
								
								var url=$(this).attr("data-url");
								var ID=$(this).attr("data-code");
								var title=$(this).attr("data-title");
								var realUrl = "dhcwlredirect.csp?url=" + url;
								/*
								var obj = window.open(realUrl,title,' left=20,top=20,width=1366,height=628,scrollbars,resizable=no,toolbar=no,depended=yes');
								productWindowOpen[ID] = obj;
								*/
								var realUrl = "dhcwlredirect.csp?url=" + url;
								if (window.opener.productWindowOpen.hasOwnProperty(ID)){
									obj = window.opener.productWindowOpen[ID];
									if (!obj.closed){
										obj.focus();
										return;
									}
								}
								
								var obj = window.open(realUrl,title,' left=20,top=20,width='+ (window.opener.screen.availWidth - 60) +',height='+ (window.opener.screen.availHeight-90) +',scrollbars,resizable=no,toolbar=no,depended=yes,menubar=no,location=no, status=no');
								window.opener.productWindowOpen[ID] = obj;							 
														 
							 }
						}
					});	
						
					
				}

		})
	};
	
	GetRptList("");


});
var ToggleDiv=function(btnObj,selStr){
		$("#"+selStr).animate({
	      height:'toggle'
    	});	
    	
		var text=$(btnObj).text();
		if ($.trim(text)=="展开") {
			$(btnObj).html("<span class=\"l-btn-left l-btn-icon-left\"><span class=\"l-btn-text\">折叠</span><span class=\"l-btn-icon icon-w-arrow-up\">&nbsp;</span></span>");
		}else{
			$(btnObj).html("<span class=\"l-btn-left l-btn-icon-left\"><span class=\"l-btn-text\">展开</span><span class=\"l-btn-icon icon-w-arrow-down\">&nbsp;</span></span>");
		}    	
    		
	}