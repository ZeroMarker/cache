/**
 * @description: js分页
 * @param {*} el 分页容器
 * @param {*} count 总记录数
 * @param {*} pageStep 每页显示多少个
 * @param {*} pageNum  pageNum:第几页
 * @param {*} fnGo  分页跳转函数    
 * @return {*}
 */        

(function (window) {
    
    var jsPage = function (el, pageStep, pageNum, fnGo, option,callback) {
	    
	    this.callback=callback;
		// 插件的返回数据
	    var drugData = {}; 
	    // 总页数
	    var count = 0;
	    
	    // 加载方法
	    this.loadDrugList = function(option){
		    var params = option.params;
		    var type = params.type;
		    var input = params.input;
		    var userInfo = params.userInfo;
		    var cattype = params.cattype;
		    if (input == ""){
				return;
			}						
			runClassMethod("web.DHCCKBPdssIndex","queryDrugListByType",{"page":pageNum,"rows":pageStep,"queryType":type,"queryStr":input,"userInfo":userInfo,"cattype":cattype},function(res){
				drugData = res;
				count = drugData.total;
			},'json',false);				
		}
	    	   	    
	    // 分页切换事件
        this.getLink = function (index, pageNum, text) {
            //var s = '<a href="#p' + index + '" onclick="' + fnGo + '(' + index + ','+ count + ');" ';  
            var goNum = (text=="首页")?1:(text=="末页"?Math.ceil(count / pageStep):index);
            var s = '<a ' + index + '" onclick="' + 'togglePage' + '('+goNum+');" ';  
            if (text||"") {
                if ((text.indexOf('首页') != -1) || (text.indexOf('末页') != -1)){
                    s += 'class="tippage" ';
                }               
            }
            else {
                if (index == pageNum) {
                    s += 'class="aselect" ';
                }
                text = text || index;
              
            }
            s += '>'+ text + '</a> ';
            return s; 
        }
        
        // 切换
        this.togglePage = function(goNum){
	        	        
	        pageNum = goNum;	        
	        this.loadDrugList(option);
	         //总页数
	        var pageNumAll = Math.ceil(count / pageStep);
	        
	        if (pageNumAll == 1) {
	            //document.getElementById(el).innerHTML = '';
	            //return;
	        }	        
	        var s = '<span>共'+pageNumAll+'页，跳转<input type="text" id="skipPage" onblur="skipPage(this)"/>页</span>';
	        // 首页和末页默认存在
	        s += this.getLink(1, pageNum, '首页');
	        // if (pageNumAll > 1) {
	        //     s += this.getLink(fnGo, 1, pageNum, '首页');
	        // }
	        var itemNum = 3; //当前页左右两边显示个数
	        pageNum = Math.max(pageNum, 1);
	        pageNum = Math.min(pageNum, pageNumAll);      
	        if (pageNum > 1) {           
	            s += this.getLink(pageNum - 1, pageNum, '&lt;');
	        } 
	        var begin = 1;
	        if (pageNum - itemNum > 1) {
	            s += this.getLink(1, pageNum) + '... ';
	            begin = pageNum - itemNum;
	        }
	        var end = Math.min(pageNumAll, begin + itemNum * 2);
	        if (end == pageNumAll - 1) {
	            end = pageNumAll;
	        }
	        
	        for (var i = begin; i <= end; i++) {
	            s += this.getLink(i, pageNum);
	        }
	        if (end < pageNumAll) {
	            s += '... ' + this.getLink(pageNumAll, pageNum);
	        }
	        if (pageNum < pageNumAll) {
	            s += this.getLink(pageNum + 1, pageNum, '&gt;');
	            // s += this.getLink(fnGo, pageNumAll, pageNum, '末页');
	        }
	        s += this.getLink(pageNumAll, pageNum, '末页');
	        var divPage = document.getElementById(el);
	        divPage.innerHTML = s;
	        if (pageNumAll == 1) {
	            divPage.innerHTML = '';
	            //return;
	        }
	       
	        this.callback(drugData,option);	      
	    }
    
    	// 执行加载数据方法
    	this.loadDrugList(option);
    	
    	// 执行加载数据方法
    	this.togglePage(pageNum);
    	
    	// 输入页数跳转
    	this.skipPage = function(e){
	    	var num = e.value;
	    	if (num == ""){
		    	return;
		    }
	    	num = (num == undefined)?1:(parseInt(num)== "NaN")?1:parseInt(num);
	    	this.togglePage(num);
	    }
	    
	    $(document).on('keydown', "#skipPage", function(event){
		    var keyCode = event.keyCode||event.which;
			if(keyCode == "13"){
				$('#skipPage').blur();
			}
		});
    }   
    
    window.jsPage = jsPage;
})(this);
