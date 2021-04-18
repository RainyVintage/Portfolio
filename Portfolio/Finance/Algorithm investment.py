# -*- coding: utf-8 -*-
"""
Created on Tue Mar  3 16:57:58 2020

@author: dazna
"""
from pandas_datareader import data
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

tickers=['ATVI','LHA.DE','SBUX','WMT']


def decision():
    stock=input("Which stock you want to invest in?: ")
    tickers.append(stock)
    a = input("Do you want to invest in more stocks? Y/N: ")
    if  a =='Y':
         return decision()
    elif a == 'N':
        return tickers
    else:
        return tickers



start='2011-01-01'
end='2020-01-01'

def DA_data(tickers, start, end):
    stock_data=data.DataReader(tickers, data_source='yahoo', start=start, end=end)['Adj Close']
    return stock_data

result_data=DA_data(tickers, start, end)
stock_returns=result_data.pct_change()
stock_returns=stock_returns.dropna()
cov_matrix=stock_returns.cov()
miu=stock_returns.mean()
iterations=1000
simulation_res= np.zeros((4+len(tickers)-1,iterations))
list1=['miu','sigma', 'SR']
list1=list1+tickers
rfr_data=data.DataReader('^TNX', data_source='yahoo', start=start, end=end)['Adj Close']
bond_data=data.DataReader('LQD', data_source='yahoo', start=start, end=end)['Adj Close']
bond_returns=bond_data.pct_change()
bond_returns=bond_returns.dropna()
bond_mean=bond_returns.mean()
rfr_data=rfr_data/100
rfr_mean=rfr_data.mean()/252

def optimization_SR(iterations=iterations):    
    for i in range(iterations):
        weights = np.array(np.random.random(len(tickers)))
        weights /=np.sum(weights)
        portfolio_return=np.sum(miu*weights)
        portfolio_sigma = np.sqrt(np.dot(weights.T,np.dot(cov_matrix, weights)))
        simulation_res[0,i]=portfolio_return*252
        simulation_res[1,i]=portfolio_sigma
        simulation_res[2,i] = (simulation_res[0,i]-rfr_mean)/simulation_res[1,i]
        for j in range(len(weights)):
            simulation_res[j+3,i]=weights[j]

    dframe = pd.DataFrame(simulation_res.T)
    dframe.columns=list1

    return dframe

stock_weight=0.6
def optimization_weight(stock_weight=0.6):
    bond_weight=1-stock_weight
    portfolio_return=optimization_SR()['miu']
    portfolio_freturn=np.dot(portfolio_return,stock_weight)
    stock_weights=optimization_SR()[3:len(tickers)+3]
    stock_fweights=stock_weights*stock_weight
    total_return_portfolio=portfolio_freturn +(bond_mean*bond_weight)
    data = {'portfolio_return':[total_return_portfolio],'stock_weight':[stock_fweights],'bond_weight':[bond_weight]}
    return data




"""
def optimization_sortino(iterations=1000):
    for i in range(iterations):
        weights = np.array(np.random.random(2))
        weights /=np.sum(weights)
        portfolio_returns=np.sum((stock_returns*weights))
        portfolio_return=np.sum(miu*weights)
        portfolio_sigma = np.sqrt(np.dot(weights.T,np.dot(cov_matrix, weights)))
        DD=(portfolio_returns-0.000081)
        if DD < 0:
            DD**2
        else:
            0
        TDD=np.sqrt((np.sum(DD))/len(portfolio_returns))
        simulation_res[0,i]=portfolio_return
        simulation_res[1,i]=portfolio_sigma
        simulation_res[2,i] = (simulation_res[0,i]-0.000081)/simulation_res[1,i]
        simulation_res[3,i] = (simulation_res[0,i]-0.000081)/TDD
        for j in range(len(weights)):
            simulation_res[j+3,i]=weights[j]

    dframe = pd.DataFrame(simulation_res.T, columns=['miu','sigma','SR','Sortino',tickers[0], tickers[1]])

    min_sortino=dframe.iloc[dframe['sortino'].idxmin()]
    return min_sortino
"""
    
def strategy():
    familiar=input("Are you familiar with portfolio management techniques? Y/N: ")
    if familiar=='Y':
        optimization_method=input("How do you want to optimize your portfolio? (SR:Sharpe Ratio, sigma:standard deviation: ")
        if optimization_method=='SR':
            print("The portfolio that maximizes your Sharpe Ratio is:\n", optimization_SR())
        elif optimization_method=="sortino":
            print("The portfolio that minimizes your standard deviation is", optimization_sigma())
    else:
        risk_profile=input("How would you say your risk aversion is? H/M/L: ")
        if risk_profile=='H':
            print("The portfolio that minimizes your standard deviation is\n", optimization_sigma())
        elif risk_profile=='M':
            print("The portfolio that maximizes your Sharpe Ratio is\n",max_SR['SR'],optimization_weight(0.6))
        elif risk_profile=='L':
            print("The portfolio that maximizes your Sharpe Ratio is\n", optimization_SR())
    
strategy()

results_frame = optimization_SR(iterations=iterations)  
##plot
#locate position of portfolio with highest Sharpe Ratio
max_sharpe_port = results_frame.iloc[results_frame['SR'].idxmax()]
#locate positon of portfolio with minimum standard deviation
min_vol_port = results_frame.iloc[results_frame['sigma'].idxmin()]
#create scatter plot coloured by Sharpe Ratio
plt.subplots(figsize=(15,10))
plt.scatter(results_frame.sigma,results_frame.miu,c=results_frame.SR,cmap='RdYlBu')
plt.xlabel('Standard Deviation')
plt.ylabel('Returns')
plt.colorbar()
#plot red star to highlight position of portfolio with highest Sharpe Ratio
plt.scatter(max_sharpe_port[1],max_sharpe_port[0],marker=(5,1,0),color='r',s=500)
#plot green star to highlight position of minimum variance portfolio
plt.scatter(min_vol_port[1],min_vol_port[0],marker=(5,1,0),color='g',s=500)
plt.show()

max_sharpe_port.to_frame().T

min_vol_port.to_frame().T