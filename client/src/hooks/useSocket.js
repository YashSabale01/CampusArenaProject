import { useEffect, useState } from 'react';
import io from 'socket.io-client';

const useSocket = () => {
  const [socket, setSocket] = useState(null);
  const [notifications, setNotifications] = useState([]);

  useEffect(() => {
    const newSocket = io(process.env.REACT_APP_API_URL?.replace('/api', '') || 'http://13.126.221.59:8000');
    setSocket(newSocket);

    newSocket.on('notification', (notification) => {
      setNotifications(prev => [notification, ...prev.slice(0, 9)]);
    });

    return () => newSocket.close();
  }, []);

  const joinEvent = (eventId) => {
    if (socket) {
      socket.emit('join-event', eventId);
    }
  };

  return { socket, notifications, joinEvent };
};

export default useSocket;