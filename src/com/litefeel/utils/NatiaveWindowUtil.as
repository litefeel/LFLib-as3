package com.litefeel.utils 
{
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.utils.Dictionary;
	
	/**
	 * www.litefeel.com
	 * lite3@qq.com
	 * @author lite3
	 */
	public class NatiaveWindowUtil 
	{
		static private const modalKeyMap:Dictionary = new Dictionary();
		static private const backKeyMap:Dictionary = new Dictionary();
		
		/**
		 * 使窗口变成 模式的,就是其他窗口不能用
		 * @param	window
		 * @param	backWindow 显示在window下面的窗口
		 */
		static public function makeModal(modalWindow:NativeWindow, backWindow:NativeWindow = null):void
		{
			if (modalKeyMap[modalKeyMap] || backKeyMap[backWindow]) return;
			
			modalWindow.activate();
			modalWindow.orderToFront();
			
			var mouseChildren:Boolean = backWindow ? backWindow.stage.mouseChildren : false;
			var vo:ModalVo = new ModalVo(modalWindow, backWindow, mouseChildren);
			modalKeyMap[modalWindow] = vo;
			if (backWindow) backKeyMap[backWindow] = vo;
			
			modalWindow.addEventListener(Event.DEACTIVATE, deactivateHandler);
			modalWindow.addEventListener(Event.ACTIVATE, deactivateHandler);
			modalWindow.addEventListener(Event.CLOSE, closingHandler);
			modalWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, displayStateChangingHandler);
			
			if (backWindow)
			{
				backWindow.stage.mouseChildren = false;
				backWindow.addEventListener(Event.DEACTIVATE, deactivateHandler);
				backWindow.addEventListener(Event.ACTIVATE, deactivateHandler);
				backWindow.addEventListener(Event.CLOSE, closingHandler);
				backWindow.addEventListener(NativeWindowBoundsEvent.MOVING, movingHandler);
				backWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, displayStateChangingHandler);
			}
		}
		
		
		
		static public function cancelModal(modalWindow:NativeWindow):void
		{
			var vo:ModalVo = modalKeyMap[modalWindow] as ModalVo;
			if (!vo) return;
			
			delete modalKeyMap[vo.modal];
			vo.modal.removeEventListener(Event.DEACTIVATE, deactivateHandler);
			vo.modal.removeEventListener(Event.ACTIVATE, deactivateHandler);
			vo.modal.removeEventListener(Event.CLOSE, closingHandler);
			vo.modal.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, displayStateChangingHandler);
			
			if (vo.back)
			{
				delete backKeyMap[vo.back];
				vo.back.stage.mouseChildren = vo.mouseChildren;
				vo.back.removeEventListener(Event.DEACTIVATE, deactivateHandler);
				vo.back.removeEventListener(Event.ACTIVATE, deactivateHandler);
				vo.back.removeEventListener(Event.CLOSE, closingHandler);
				vo.back.removeEventListener(NativeWindowBoundsEvent.MOVING, movingHandler);
				vo.back.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, displayStateChangingHandler);
			}
		}
		
		static private function deactivateHandler(e:Event):void 
		{
			var vo:ModalVo = getModal(NativeWindow(e.currentTarget));
			if (!vo) return;
			
			switch(e.type)
			{
				case Event.ACTIVATE :
					if (vo.back == e.currentTarget) vo.modal.activate();
					break;
				
				case Event.DEACTIVATE :
					if (vo.modal == e.currentTarget) vo.modal.activate();
					break;
			}
		}
		
		static private function movingHandler(e:NativeWindowBoundsEvent):void 
		{
			var vo:ModalVo = getModal(NativeWindow(e.currentTarget));
			if (!vo) return;
			
			if (vo.back == e.currentTarget) e.preventDefault();
		}
		
		static private function displayStateChangingHandler(e:NativeWindowDisplayStateEvent):void 
		{
			var vo:ModalVo = getModal(NativeWindow(e.currentTarget));
			if (!vo) return;
			
			if (vo.modal == e.currentTarget || vo.back == e.currentTarget)
			{
				e.preventDefault();
			}
		}
		
		static private function closingHandler(e:Event):void 
		{
			var vo:ModalVo = getModal(NativeWindow(e.currentTarget));
			if (!vo) return;
			
			cancelModal(vo.modal);
		}
		
		[Inline]
		static private function getModal(window:NativeWindow):ModalVo
		{
			var vo:ModalVo = backKeyMap[window] as ModalVo;
			if (!vo) vo = modalKeyMap[window] as ModalVo;
			return vo;
		}
		
	}
	
}
import flash.display.NativeWindow;

class ModalVo
{
	public var modal:NativeWindow;
	public var back:NativeWindow;
	public var mouseChildren:Boolean
	
	public function ModalVo(modal:NativeWindow, back:NativeWindow, mouseChildren:Boolean)
	{
		this.modal = modal;
		this.back = back;
		this.mouseChildren = mouseChildren;
	}
}