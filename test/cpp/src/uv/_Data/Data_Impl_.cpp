// Generated by Haxe 4.2.0-rc.1+d0fd88b9b
#include <hxcpp.h>

#ifndef INCLUDED_uv__Data_Data_Impl_
#include <uv/_Data/Data_Impl_.h>
#endif

HX_LOCAL_STACK_FRAME(_hx_pos_032eba5ea5730279_7_fromPointer,"uv._Data.Data_Impl_","fromPointer",0x450f6241,"uv._Data.Data_Impl_.fromPointer","uv/Data.hx",7,0x7c9fedc6)
HX_LOCAL_STACK_FRAME(_hx_pos_032eba5ea5730279_8_toPointer,"uv._Data.Data_Impl_","toPointer",0xbfe886d0,"uv._Data.Data_Impl_.toPointer","uv/Data.hx",8,0x7c9fedc6)
HX_LOCAL_STACK_FRAME(_hx_pos_032eba5ea5730279_10_fromAny,"uv._Data.Data_Impl_","fromAny",0xb7df8a70,"uv._Data.Data_Impl_.fromAny","uv/Data.hx",10,0x7c9fedc6)
HX_LOCAL_STACK_FRAME(_hx_pos_032eba5ea5730279_11_toAny,"uv._Data.Data_Impl_","toAny",0x05697b7f,"uv._Data.Data_Impl_.toAny","uv/Data.hx",11,0x7c9fedc6)
namespace uv{
namespace _Data{

void Data_Impl__obj::__construct() { }

Dynamic Data_Impl__obj::__CreateEmpty() { return new Data_Impl__obj; }

void *Data_Impl__obj::_hx_vtable = 0;

Dynamic Data_Impl__obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< Data_Impl__obj > _hx_result = new Data_Impl__obj();
	_hx_result->__construct();
	return _hx_result;
}

bool Data_Impl__obj::_hx_isInstanceOf(int inClassId) {
	return inClassId==(int)0x00000001 || inClassId==(int)0x65b43192;
}

void* Data_Impl__obj::fromPointer(::cpp::Pointer<  ::Dynamic > v){
            	HX_STACKFRAME(&_hx_pos_032eba5ea5730279_7_fromPointer)
HXDLIN(   7)		return ( (void*)(v->get_raw()) );
            	}


::cpp::Pointer<  ::Dynamic > Data_Impl__obj::toPointer(void* this1){
            	HX_STACKFRAME(&_hx_pos_032eba5ea5730279_8_toPointer)
HXDLIN(   8)		return ::cpp::Pointer_obj::fromRaw(this1)->reinterpret();
            	}


void* Data_Impl__obj::fromAny( ::Dynamic v){
            	HX_STACKFRAME(&_hx_pos_032eba5ea5730279_10_fromAny)
HXDLIN(  10)		return v.GetPtr();
            	}


 ::Dynamic Data_Impl__obj::toAny(void* this1){
            	HX_STACKFRAME(&_hx_pos_032eba5ea5730279_11_toAny)
HXDLIN(  11)		return (hx::Object*)this1;
            	}



Data_Impl__obj::Data_Impl__obj()
{
}

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo *Data_Impl__obj_sMemberStorageInfo = 0;
static ::hx::StaticInfo *Data_Impl__obj_sStaticStorageInfo = 0;
#endif

::hx::Class Data_Impl__obj::__mClass;

void Data_Impl__obj::__register()
{
	Data_Impl__obj _hx_dummy;
	Data_Impl__obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("uv._Data.Data_Impl_",3c,a1,3c,39);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &::hx::Class_obj::GetNoStaticField;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(0 /* sStaticFields */);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(0 /* sMemberFields */);
	__mClass->mCanCast = ::hx::TCanCast< Data_Impl__obj >;
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = Data_Impl__obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = Data_Impl__obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

} // end namespace uv
} // end namespace _Data
