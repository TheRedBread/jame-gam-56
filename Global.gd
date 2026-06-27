extends Node

@export var employee_price : int = 2

var carrots_currency : float = 10
var carrots_in_process : int = 0
var carrots : int = 0
var processed_carrots : int = 0
var processed_carrots_value : float = 1.5
var carrots_on_ground : int = 0
@export var carrot_spawn_rate : float = 0.2

@export var farmer_avg_paygrade : float = employee_price*1./10.
@export var worker_avg_paygrade : float = employee_price*2./10.
@export var manager_avg_paygrade : float = employee_price*3./10.

var farmer_paygrade : float = farmer_avg_paygrade
var worker_paygrade : float = worker_avg_paygrade
var manager_paygrade : float = manager_avg_paygrade
