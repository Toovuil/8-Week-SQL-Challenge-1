-- clean customer_orders table

-- update exclusions
update customer_orders
set exclusions =	Case
	  WHEN exclusions = '' THEN NULL 
	  WHEN exclusions = 'null' THEN NULL 
	  ELSE exclusions
	END

-- update extras
	update customer_orders
set extras =	Case
	  WHEN extras = '' THEN NULL 
	  WHEN extras = 'null' THEN NULL 
	  ELSE extras
	END

--update distance
	update runner_orders
set distance =	Case
	  WHEN distance = '' THEN NULL 
	  WHEN distance = 'null' THEN NULL 
	  ELSE distance
	END

--update duration
update runner_orders
set duration =	
Case
	  WHEN duration = '' THEN NULL 
	  WHEN duration = 'null' THEN NULL 
	  ELSE duration
END

--update cancellation
update runner_orders
set cancellation =	
Case
	  WHEN cancellation = '' THEN NULL 
	  WHEN cancellation = 'null' THEN NULL 
	  ELSE cancellation
END

--update pickup_time
update runner_orders
set pickup_time =	
Case
	  WHEN pickup_time = '' THEN NULL 
	  WHEN pickup_time = 'null' THEN NULL 
	  ELSE pickup_time
END
