/**!
* date:2019-04-02
* desc：DLL/ocx插件接口调用封装js【模板,参考】
* 接口厂家：
* creator：郭荣勇
*/

//业务界面触发的事件接口调用函数，例如：合理用药的【药典提示】
function templateBtn_Click(){
	XXX_Interface.Funcs.QueryFunc();
}

//供业务界面调用，调用接口函数A
function template_InterfaceA(){
	XXX_Interface.Funcs.HanderFunA();
}

//供业务界面调用，调用接口函数B
function template_InterfaceB(){
	XXX_Interface.Funcs.HanderFunB()
}


//接口函数封装
var XXX_Interface={
	Funcs:{
		QueryFunc:function () {
			var Data=this.getData();
			var Data=this.FormatData(Data);
		    ///todo 二次开发API接口函数调用
		    ///...
		    return Data;
		},
		///接口函数A
		HanderFunA:function () {
		    var myrtn="";
		    ///todo 二次开发API接口函数调用
		    ///...
		    return myrtn;
		},
		///接口函数B
		HanderFunB:function (){
			var myrtn="";
		    ///todo 二次开发API接口函数调用
		    ///...
		    return myrtn;
		},
		//通过前端获取数据函数【示意】
		getData:function () {
		    var jsonRtn={};
		    ///todo 根据需要获取页面数据处理
		    ///...
			
		   return jsonRtn;
		},
		//公共函数【示意】
		FormatData:function (Data) {
		    ///todo 根据需要格式化数据
		    ///...
		    
		    return Data;
		   
		}
	}
}




