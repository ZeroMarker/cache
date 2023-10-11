//页面Event
function InitWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    //动态加载菜单   	
     	obj.loadMenu();     	   	
     	obj.tabClose();	
     	//延时0.5秒执行绑定事件，防止动态菜单未生成完成	
     	setTimeout(function(){
	     	$('.api-navi-tab').click(function() {
	            var $this = $(this);
	            var href = $this.attr('src');
	            var title = $this.text();
	            obj.addTab(title, href);
	        });
	    },500);
        $('#tabs').tabs("options").onSelect=function(title,index){
            $(".api-navi-tab").each(function(){
                $(this).closest("li").removeClass('active');
                if ($(this).text()==title){
                    $(this).closest("li").addClass('active');
                }
            });
        }        
	};
	obj.addTab =function(title, url){
        if ($('#tabs').tabs('exists', title)){
            $('#tabs').tabs('select', title);   //选中并刷新
            var currTab = $('#tabs').tabs('getSelected');
            var url = $(currTab.panel('options').content).attr('src');
            if ("undefined" !==typeof websys_getMWToken) {
	url  += "&MWToken="+websys_getMWToken();
           }
            if(url != undefined && currTab.panel('options').title != '首页') {
                $('#tabs').tabs('update',{
                    tab:currTab,
                    options:{
                        content:obj.createFrame(url)
                    }
                })
            }
        }else{
            var content = obj.createFrame(url);
            $('#tabs').tabs('add',{
                style:{overflow:'hidden'},
                title:title,
                content:content,
                closable:true
            });
        }
    };
    obj.createFrame=function(url) {
        var s = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
        return s;
    };
    //改为在jQuery加载完成调用 不再增加一个tab调用一次
    obj.tabClose=function() {
        /*双击关闭TAB选项卡*/
        $('.tabs-header').on('dblclick','.tabs-inner',function(){
            var subtitle = $(this).children(".tabs-closable").text();
            $('#tabs').tabs('close',subtitle);
        }).on('contextmenu','.tabs-inner',function(e){
            e.preventDefault();
            var subtitle =$(this).children(".tabs-title").text();    //不嫩用.tabs-closable
            //做一些右键菜单的禁用启用
            if (subtitle=="首页"){
                $('#mm').menu('disableItem',$('#mm-tabupdate')[0]);
                $('#mm').menu('disableItem',$('#mm-tabclose')[0]);
            }else{
                $('#mm').menu('enableItem',$('#mm-tabupdate')[0]);
                $('#mm').menu('enableItem',$('#mm-tabclose')[0]);
            }

            var leftnum=$('.tabs-selected').prevAll().length;
            if(leftnum>1){  //有个首页 要大于1
                $('#mm').menu('enableItem',$('#mm-tabcloseleft')[0]);
            }else{
                $('#mm').menu('disableItem',$('#mm-tabcloseleft')[0]);
            }
            var rightnum=$('.tabs-selected').nextAll().length;
            if(rightnum>0){
                $('#mm').menu('enableItem',$('#mm-tabcloseright')[0]);
            }else{
                $('#mm').menu('disableItem',$('#mm-tabcloseright')[0]);
            }

            if (leftnum>1 || rightnum>0 ){
                $('#mm').menu('enableItem',$('#mm-tabcloseother')[0]);
            }else{
                $('#mm').menu('disableItem',$('#mm-tabcloseother')[0]);
            }
            $('#mm').menu('show', {
                left: e.pageX,
                top: e.pageY
            });
            $('#mm').data("currtab",subtitle);
            $('#tabs').tabs('select',subtitle);
            return false;
        });
    };
    
    obj.loadMenu=function()
    {
	    obj.accObj = $HUI.accordion("#accd");
	    //分类加载 同步调用
	    var rst = $cm({
	        ClassName: "DHCHAI.BTS.DictionarySrv",
	        QueryName: "QryDic",
	        aTypeCode: "BTMenuType",
	        aActive: "",
	        page: 1,
	        rows: 999
	    }, false);
	    for (var i=0;i<rst.rows.length;i++)
		{
			//;根据角色和模块值取子菜单内容
			var rstCd = $cm({
		        ClassName: "DHCHAI.BTS.UserMenuSrv",
		        QueryName: "QryUserMenu",
		        aUserGrpCode: jsCode,
		        aMenuTypeID: rst.rows[i].ID,
		        page: 1,
		        rows: 999
		    }, false);
		    var tmpLi ="";
		    for (var ii=0;ii<rstCd.rows.length;ii++)
			{
				var tmpLi =tmpLi+'<li><a href="javascript:void(0);" src="'+rstCd.rows[ii].MenuUrl+'" class="api-navi-tab">'+rstCd.rows[ii].MenuDesc+'</a></li>';
			}
			var contentStr = "";
			if(tmpLi!="")
			{
				contentStr = '<ul id="ul'+rst.rows[i].ID+'">'+tmpLi+'</ul>';
			}		
			obj.accObj.add({
	            title:rst.rows[i].DicDesc,
	            //iconCls:'icon-w-add',
	            content:contentStr,
	            //selected:true //,
	            style:{backgroundColor:'#F9F9F9'}
	        });
		}
	}
    
}