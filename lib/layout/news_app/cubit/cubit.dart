import 'package:bloc/bloc.dart';
import 'package:firstapi_flutter/layout/news_app/cubit/states.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../modules/news_app/bussiness/bussiness_screen.dart';
import '../../../modules/news_app/science/science_screen.dart';
import '../../../modules/news_app/sports/sport_screen.dart';
import '../../../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.business_sharp),
      label: 'bussiness'
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.sports),
        label: 'Sports'
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.science),
        label: 'Science'
    ),

  ];
  List<Widget> Screens = [
    BusinessScreen(),
    SportScreen(),
    ScienceScreen(),

  ];

  void changeBottomNavBar(int index)
  {
    currentIndex=index;

    emit(NewsBottomNavstate());
  }

  List <dynamic> business = [];
  void getBusiness()
  {
    emit(NewsLoadingState());
    DioHelper.getData(url: 'v2/top-headlines',
      query: {
        'country':'us',
        'category':'business',
        'apiKey':'3a1327ddebc14901bebd13a5b1e63588',
      },
    ).then((value)
    {
      // print(value?.data.toString());
      business=value?.data['articles'];
      // print(business[0]['author']);
      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      emit(NewsGetBusinessErrorState(error.toString()));
      print(error.toString());
    });
  }

  List <dynamic> sports = [];
  void getSports()
  {
    emit(NewsGetSportsLoadingState());
    if(sports.length == 0)
    {
      DioHelper.getData(url: 'v2/top-headlines',
        query: {
          'country':'us',
          'category':'sport',
          'apiKey':'3a1327ddebc14901bebd13a5b1e63588',
        },
      ).then((value)
      {
        // print(value?.data.toString());
        sports=value?.data['articles'];
        // print(business[0]['author']);
        emit(NewsGetSportsSuccessState());
      }).catchError((error){
        emit(NewsGetSportsErrorState(error.toString()));
        print(error.toString());
      });
    } else
      {
        emit((NewsGetSportsSuccessState()));
      }

  }

  List <dynamic> science = [];
  void getScience()
  {
    emit(NewsGetScienceLoadingState());
    if(science.length == 0)
    {
      DioHelper.getData(url: 'v2/top-headlines',
        query: {
          'country':'us',
          'category':'science',
          'apiKey':'3a1327ddebc14901bebd13a5b1e63588',
        },
      ).then((value)
      {
        // print(value?.data.toString());
        science=value?.data['articles'];
        // print(business[0]['author']);
        emit(NewsGetScienceSuccessState());
      }).catchError((error){
        emit(NewsGetScienceErrorState(error.toString()));
        print(error.toString());
      });
    }else{
      emit(NewsGetScienceSuccessState());

    }

  }
  List <dynamic> search = [];
  void getSearch(String value)
  {
    emit(NewsGetScienceLoadingState());
    search=[];
    DioHelper.getData(url: 'v2/everything',
      query: {
        'q':'$value',
        'apiKey':'3a1327ddebc14901bebd13a5b1e63588',
      },
    ).then((value)
    {
      search=value?.data['articles'];
      // print(search[0]['author']);
      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      emit(NewsGetScienceErrorState(error.toString()));
      print(error.toString());
    });

      emit(NewsGetSearchSuccessState());



  }


}
