/// ext.websys.Lookup.List.js
/// look up 


//var m_PageHeight=200;
//var m_PageWidth=300;
/// 对于Lookup调整
///150 最低的高度
///没有数据时显示  500
///有显示页数时  150+30*PageSize
var m_PageHeight=500;
var m_PageWidth=400;
var m_PageSize=15;
var m_ByteWidth=7;
var grid,pagingBar;	//这了实现pagedown与pageup
function ResizePageHandler(rows, cols) {
	if (m_PageSize>0){
		m_PageHeight=150+(25*15);
	} 
	if (m_PageWidth<350){
		m_PageWidth=400;
		}
	else{
		var screenWidth=top.window.screen.width*0.8;
		if (m_PageWidth > screenWidth){
			m_PageWidth = screenWidth;
		}
	}
	window.resizeTo(m_PageWidth, m_PageHeight);
}

Ext.onReady(function(){
		Ext.QuickTips.init();
		var myclassname="";		
		var myqueryname="";

    Ext.getUrlParam = function(param) {
        var str = location.search.substring(1);	 
        var ind = str.indexOf(param+"=");
        if (ind>-1){
	        var start = ind+param.length+1;
	        var end = str.indexOf("&",start);
	        if (end==-1) return str.slice(start);
        	return str.slice(start,end);
        }
        return "";
        var params = Ext.urlDecode(location.search.substring(1));
        return param ? params[param] : params;
    };
		
		var myID=Ext.getUrlParam('ID');
		var myCONTEXT=Ext.getUrlParam("CONTEXT");
		var mycontextary=myCONTEXT.split(":");
		
		///获取Query定义
		myclassname=mycontextary[0].substring(1);
		myqueryname=mycontextary[1];

		/// 获取参数定义, 本页面的参数都是固定的， 由调用界面提供
		var myparacount=20;
		var myparastr="";
		var mypvalue="";
		myparastr= "'pClassName' : '" + myclassname + "', ";
		myparastr += "'pClassQuery' : " + "'"+myqueryname +"'";
		
		///将request参数组织为json格式
		for (var myIdx=1; myIdx<myparacount; myIdx++){
			mypvalue=Ext.getUrlParam("P"+myIdx);
			if ((typeof(mypvalue)=="undefined")||(mypvalue==null)){
				continue;
			}
			if (myparastr!=""){
				myparastr+=", ";
			}
			myparastr+=("'P"+myIdx)+ "' : " + "'"+mypvalue+"'";
		}
		if (myparastr!=""){
				myparastr+=", ";
		}
		myparastr+="'rnd' : '"+Math.random()+"'";
		myparastr="{"+myparastr+"}";
		var myparajson=Ext.decode(myparastr);
		
		
		/// 获得grid定义metdata
		var mymodalstr=tkMakeServerCall("ext.websys.QueryBroker", "ReadRS", myclassname, myqueryname);
		var json=Ext.decode(mymodalstr);
		var cm = new Ext.grid.ColumnModel(json.cms);
		
		/// 定义datastors
		var mycmurl="ext.websys.querydatatrans.csp";
		var ds = new Ext.data.JsonStore({
	      url:mycmurl,
	      baseParams:myparajson,
	      root:"record",
	      totalProperty:"total",
	      fields: json.fns
    });
    
    /// 定义pagingBar
    pagingBar = new Ext.PagingToolbar({
	            pageSize: 15,
	            store: ds,
	            displayInfo: true,
	            displayMsg: '{0}-{1},共{2}条'
	            //emptyMsg: "没有记录"
    });
    var myloadM;
		if (Ext.isIE){
			myloadM = new Ext.LoadMask(Ext.getBody(), {msg:"正在加载数据..."});
		}else{
			myloadM = true;
		}
    
  	/// 定义grid
  	grid = new Ext.grid.GridPanel({
  					id:"lookupdata",
  					title:"",
            region: 'center',
            split: true,
            border:false,
            width:80,
            height:180,
            cm:cm,
            ds:ds,
            loadMask:myloadM,
            stripeRows:true,
        	  bbar:pagingBar
		});
		
		/// grid 事件
		grid.on({
			rowclick:function(grid, rowIndex,e){
				selectRow();
			},
			keydown:function(e){
				//按键事件监听无效,websys.js内监听了keydown. websys.lookup.csp内重写keydown事件
				if (e.getKey() == e.ENTER){
					selectRow();
				}
			}
		});
		new Ext.Viewport({
			layout: 'border',
			split: true,
			items: [grid]
		});
		
		
		/// 选中行后回写数据 事件
		var selectRow = function (){
			var tmpRecord = grid.getSelectionModel().getSelected();
			var myColAry="";
				for(var myIdx=0;myIdx<json.fns.length;myIdx++){
					//wanghc 如果第一列为空,则顺序乱了
					if(myIdx==0){
						myColAry = tmpRecord.get(json.fns[myIdx].name);
					}else{
						myColAry += "^";
						myColAry += tmpRecord.get(json.fns[myIdx].name);
					}
				}
				GridRowSelect(tmpRecord.get(json.fns[0].name),myColAry);
				window.close();
				return;
				
		}
		
		/// ds.onload  加载数据后触发事件，重新计算列宽
    ds.on({
			load:function(s,rs,obj){
				m_PageWidth=0;
				for(var cm_i=0;cm_i<cm.config.length;cm_i++){
					if (cm.config[cm_i].hidden) continue;
					var objWidth=new Object;
					objWidth.key=cm.config[cm_i].dataIndex;
					objWidth.val=cm.config[cm_i].width;
					
					for(var rs_i=0;rs_i<rs.length;rs_i++){
						var len=rs[rs_i].get(objWidth.key).replace(/[^\x00-\xff]/g,"**").length * m_ByteWidth;
						if (len>objWidth.val){
							objWidth.val=len;
						}
					}
					cm.config[cm_i].width=objWidth.val;
					m_PageWidth+=objWidth.val;
			    }
				grid.reconfigure(ds,cm);
				ResizePageHandler(0, 0);
				//wanghc 21040917 第次load完都选中第一行
				grid.getSelectionModel().selectFirstRow();
	 			var row = grid.getView().getRow(0);
				if (row) Ext.get(row).focus();
		  }
    });
	ds.load({params:{start:0,limit:pagingBar.pageSize, pPageSize:pagingBar.pageSize, pPageIdx:pagingBar.pageIndex}});
});




