	//绑定tab右键菜单事件  
	function bindTabMenuEvent() {  
	    //关闭当前  
	    $('#tabclose').click(function() {  
	    
	        closeTab("close");

	    });  
	    //全部关闭  
	    $('#tabcloseall').click(function() {  
	        closeTab("closeall");  
	    });  
	    //关闭除当前之外的TAB  
	    $('#tabcloseother').click(function() {  
	        closeTab("closeother"); 
	    });  

	} 

	function closeTab(action)
	{
		var onlyOpenTitle="";
	    var alltabs = $("#maintab").tabs('tabs');
	    var currentTab =$('#maintab').tabs('getSelected');
	    var allTabtitle = [];
	    $.each(alltabs,function(i,n){
	        allTabtitle.push($(n).panel('options').title);
	    })


	    switch (action) {
	        case "refresh":
	            var iframe = $(currentTab.panel('options').content);
	            var src = iframe.attr('src');
	            $('#maintab').tabs('update', {
	                tab: currentTab,
	                options: {
	                    content: createFrame(src)
	                }
	            })
	            break;
	        case "close":
	            var currtab_title = currentTab.panel('options').title;
	            $('#maintab').tabs('close', currtab_title);
	            break;
	        case "closeall":
	            $.each(allTabtitle, function (i, n) {
	                if (n != onlyOpenTitle){
	                    $('#maintab').tabs('close', n);
	                }
	            });
	            break;
	        case "closeother":
	            var currtab_title = currentTab.panel('options').title;
	            $.each(allTabtitle, function (i, n) {
	                if (n != currtab_title && n != onlyOpenTitle)
	                {
	                    $('#maintab').tabs('close', n);
	                }
	            });
	            break;
	        case "closeright":
	            var tabIndex = $('#maintab').tabs('getTabIndex', currentTab);

	            if (tabIndex == alltabs.length - 1){
	                alert('亲ㄛ后边没有啦 ^@^!!');
	                return false;
	            }
	            $.each(allTabtitle, function (i, n) {
	                if (i > tabIndex) {
	                    if (n != onlyOpenTitle){
	                        $('#maintab').tabs('close', n);
	                    }
	                }
	            });

	            break;
	        case "closeleft":
	            var tabIndex = $('#maintab').tabs('getTabIndex', currentTab);
	            if (tabIndex == 1) {
	                alert('亲ㄛ前边那个上头有人ㄛ咱惹不起哦﹝ ^@^!!');
	                return false;
	            }
	            $.each(allTabtitle, function (i, n) {
	                if (i < tabIndex) {
	                    if (n != onlyOpenTitle){
	                        $('#maintab').tabs('close', n);
	                    }
	                }
	            });

	            break;
	        case "exit":
	            $('#closeMenu').menu('hide');
	            break;
	    }
	}